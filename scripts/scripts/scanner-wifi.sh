#!/bin/bash
set -eo pipefail

YELLOW='\033[1;33m'
GREEN='\033[1;32m'
RED='\033[1;31m'
DIM='\033[0;90m'
RESET='\033[0m'
BOLD='\033[1m'

TMPDIR_WORK=$(mktemp -d)
trap 'rm -rf "$TMPDIR_WORK"' EXIT

PARSED_FILE="$TMPDIR_WORK/parsed.txt"
touch "$PARSED_FILE"

# -- Detectar interface wireless --
# No Arch Linux, interfaces sao nomeadas dinamicamente (wlp2s0, wlp3s0, etc.)

get_wifi_iface() {
  # 1. Tentar via iw (mais confiavel no Arch)
  local iface
  iface=$(iw dev 2>/dev/null | awk '/Interface/{print $2}' | head -1)
  [ -n "$iface" ] && echo "$iface" && return

  # 2. Tentar via /sys/class/net (sempre disponivel no kernel Linux)
  for dev in /sys/class/net/*/wireless; do
    if [ -d "$dev" ]; then
      basename "$(dirname "$dev")"
      return
    fi
  done

  # 3. Fallback para nomes comuns
  for name in wlan0 wlp2s0 wlp3s0 wlp4s0; do
    if ip link show "$name" &>/dev/null 2>&1; then
      echo "$name"
      return
    fi
  done

  echo ""
}

# -- Detectar rede atual --

get_current_ssid() {
  # nmcli: mais confiavel quando NetworkManager esta ativo
  if command -v nmcli &>/dev/null; then
    nmcli -t -f active,ssid dev wifi 2>/dev/null \
      | grep '^yes:' \
      | cut -d: -f2- \
      || true
    return
  fi

  # iw: fallback sem NetworkManager
  local iface
  iface=$(get_wifi_iface)
  if [ -n "$iface" ] && command -v iw &>/dev/null; then
    iw dev "$iface" link 2>/dev/null \
      | awk '/SSID:/{$1=""; sub(/^ /, ""); print}' \
      || true
  fi
}

get_current_channel() {
  local iface
  iface=$(get_wifi_iface)

  # iw: metodo mais preciso e disponivel por padrao no Arch
  if [ -n "$iface" ] && command -v iw &>/dev/null; then
    iw dev "$iface" info 2>/dev/null \
      | awk '/channel [0-9]/{print $2}' \
      | head -1
    return
  fi

  # nmcli: fallback quando iw nao esta disponivel
  if command -v nmcli &>/dev/null; then
    local ssid
    ssid=$(get_current_ssid)
    if [ -n "$ssid" ]; then
      # Usar --escape no para preservar SSIDs com caracteres especiais
      nmcli --escape no -t -f SSID,CHAN dev wifi list 2>/dev/null \
        | awk -F'\t' -v s="$ssid" '$1 == s {print $2; exit}'
    fi
  fi
}

# -- Scan de redes --

scan_networks() {
  if command -v nmcli &>/dev/null; then
    # NetworkManager: metodo primario
    # --escape no evita que SSIDs com ':' quebrem o parse
    nmcli dev wifi rescan 2>/dev/null || true
    sleep 2  # Arch pode precisar de um pouco mais de tempo dependendo do driver

    nmcli --escape no -t -f SSID,CHAN dev wifi list 2>/dev/null \
      | while IFS=$'\t' read -r ssid chan; do
        # Filtrar entradas invalidas
        [ -z "$chan" ] && continue
        [ "$ssid" = "--" ] && continue
        [ -z "$ssid" ] && continue
        # Validar que chan e um numero
        [[ "$chan" =~ ^[0-9]+$ ]] || continue
        printf '%s|%s\n' "$chan" "$ssid" >> "$PARSED_FILE"
      done

  elif command -v iw &>/dev/null; then
    # iw: fallback sem NetworkManager (requer root para scan ativo)
    local iface
    iface=$(get_wifi_iface)

    if [ -z "$iface" ]; then
      echo -e "  ${RED}Erro: nenhuma interface wireless encontrada.${RESET}" >&2
      exit 1
    fi

    # Verificar privilégios
    if [ "$(id -u)" -ne 0 ]; then
      echo -e "  ${YELLOW}Aviso: 'iw scan' requer root. Tente: sudo $0${RESET}" >&2
    fi

    local scan_output
    scan_output=$(iw dev "$iface" scan 2>/dev/null) || {
      echo -e "  ${RED}Erro ao escanear. Execute com sudo.${RESET}" >&2
      exit 1
    }

    # Parse do output do iw (formato diferente do iwlist)
    echo "$scan_output" | awk '
    /^BSS/ {
      if (chan != "" && ssid != "") print chan "|" ssid
      chan = ""; ssid = ""
    }
    /\* primary channel:/ { chan = $NF }
    /SSID:/ {
      sub(/.*SSID: /, "")
      # Ignorar SSIDs ocultos (vazios ou so espacos)
      if ($0 ~ /[^ \t]/) ssid = $0
    }
    END {
      if (chan != "" && ssid != "") print chan "|" ssid
    }
    ' >> "$PARSED_FILE"

  else
    echo -e "  ${RED}Erro: nmcli ou iw nao encontrado.${RESET}" >&2
    echo -e "  ${DIM}No Arch Linux: sudo pacman -S networkmanager  ou  sudo pacman -S iw${RESET}" >&2
    exit 1
  fi
}

# -- Barra de sinal visual --
signal_bar() {
  local count=$1
  local bar=""
  local i=0
  while [ $i -lt 8 ]; do
    if [ $i -lt "$count" ]; then
      bar="${bar}█"
    else
      bar="${bar}░"
    fi
    i=$((i + 1))
  done
  echo "$bar"
}

# -- Contar redes num canal especifico --

count_for_channel() {
  awk -F'|' -v c="$1" '$1 == c' "$PARSED_FILE" | wc -l | tr -d ' '
}

names_for_channel() {
  awk -F'|' -v c="$1" '$1 == c {print $2}' "$PARSED_FILE" \
    | tr '\n' ',' \
    | sed 's/,$//' \
    | sed 's/,/, /g'
}

# -- Imprimir linha de canal colorida --

print_channel_line() {
  local ch=$1
  local count=$2
  local names=$3
  local bar
  bar=$(signal_bar "$count")

  # Destacar SSID da rede atual
  if [ -n "$current_ssid" ]; then
    local escaped_ssid
    escaped_ssid=$(printf '%s\n' "$current_ssid" | sed 's/[[\.*^$()+?{|]/\\&/g')
    names=$(echo "$names" | sed "s/${escaped_ssid}/${GREEN}${current_ssid}${RESET}/g")
  fi

  if [ "$count" -ge 5 ]; then
    printf "  ${RED}%4d  %d  %s${RESET}  %b\n" "$ch" "$count" "$bar" "$names"
  elif [ "$count" -ge 3 ]; then
    printf "  ${YELLOW}%4d  %d  %s${RESET}  %b\n" "$ch" "$count" "$bar" "$names"
  elif [ "$count" -eq 0 ]; then
    printf "  %4d  %d  %s  ${DIM}(vazio)${RESET}\n" "$ch" "$count" "$bar"
  else
    printf "  %4d  %d  %s  %b\n" "$ch" "$count" "$bar" "$names"
  fi
}

# ═══════════════════════════════════════
#  MAIN
# ═══════════════════════════════════════

echo ""
echo -e "  Escaneando redes Wi-Fi..."
echo ""

current_ssid=$(get_current_ssid)
current_channel=$(get_current_channel)

scan_networks

if [ ! -s "$PARSED_FILE" ]; then
  echo -e "  ${RED}Nenhuma rede encontrada.${RESET}"
  echo -e "  ${DIM}Verifique se o Wi-Fi esta ligado: nmcli radio wifi on${RESET}"
  exit 1
fi

# ── 2.4 GHz ──────────────────────────────

echo -e "  ${BOLD}Redes encontradas (2.4 GHz):${RESET}"
echo ""
printf "  %-6s %-6s %-10s %s\n" "Canal" "Redes" "Sinal" "Nomes"
printf "  %-6s %-6s %-10s %s\n" "─────" "─────" "────────" "──────────────────────────────"

best_24_ch=""
best_24_count=999

for ch in 1 2 3 4 5 6 7 8 9 10 11 12 13; do
  count=$(count_for_channel "$ch")
  names=$(names_for_channel "$ch")

  # Rastrear melhor canal nao-sobreposto (1, 6, 11)
  case $ch in
    1|6|11)
      if [ "$count" -lt "$best_24_count" ]; then
        best_24_count=$count
        best_24_ch=$ch
      fi
      ;;
  esac

  # Mostrar apenas canais com redes, exceto 1/6/11 (sempre mostrar)
  if [ "$count" -eq 0 ]; then
    case $ch in
      1|6|11) ;;
      *) continue ;;
    esac
  fi

  print_channel_line "$ch" "$count" "$names"
done

echo ""

# ── 5 GHz ────────────────────────────────

CHANNELS_5GHZ=(36 40 44 48 52 56 60 64 100 104 108 112 116 120 124 128 132 136 140 149 153 157 161 165)

has_5ghz=false
best_5_ch=""
best_5_count=999

for ch in "${CHANNELS_5GHZ[@]}"; do
  count=$(count_for_channel "$ch")
  if [ "$count" -gt 0 ]; then
    has_5ghz=true
    break
  fi
done

if $has_5ghz; then
  echo -e "  ${BOLD}Redes encontradas (5 GHz):${RESET}"
  echo ""
  printf "  %-6s %-6s %-10s %s\n" "Canal" "Redes" "Sinal" "Nomes"
  printf "  %-6s %-6s %-10s %s\n" "─────" "─────" "────────" "──────────────────────────────"

  for ch in "${CHANNELS_5GHZ[@]}"; do
    count=$(count_for_channel "$ch")
    names=$(names_for_channel "$ch")

    [ "$count" -eq 0 ] && continue

    if [ "$count" -lt "$best_5_count" ]; then
      best_5_count=$count
      best_5_ch=$ch
    fi

    print_channel_line "$ch" "$count" "$names"
  done

  # Procurar canal 5 GHz totalmente livre
  for ch in "${CHANNELS_5GHZ[@]}"; do
    count=$(count_for_channel "$ch")
    if [ "$count" -eq 0 ]; then
      [ -z "$best_5_ch" ] && { best_5_ch=$ch; best_5_count=0; }
      break
    fi
  done

  echo ""
fi

# ── Diagnostico ───────────────────────────

echo "  ─────────────────────────────────"
echo -e "  ${BOLD}Diagnostico:${RESET}"
echo ""

iface=$(get_wifi_iface)
if [ -n "$iface" ]; then
  echo -e "  Interface:     ${DIM}$iface${RESET}"
fi

if [ -n "$current_ssid" ]; then
  echo -e "  Sua rede:    ${GREEN}$current_ssid${RESET}"
else
  echo -e "  Sua rede:    ${DIM}(nao detectada)${RESET}"
fi

if [ -n "$current_channel" ]; then
  current_count=$(count_for_channel "$current_channel")
  if [ "$current_count" -ge 5 ]; then
    echo -e "  Canal atual:   ${RED}$current_channel — CONGESTIONADO ($current_count redes)${RESET}"
  elif [ "$current_count" -ge 3 ]; then
    echo -e "  Canal atual:   ${YELLOW}$current_channel — MODERADO ($current_count redes)${RESET}"
  else
    echo -e "  Canal atual:   ${GREEN}$current_channel — BOM ($current_count redes)${RESET}"
  fi
fi

echo ""
echo -e "  ${BOLD}Recomendacao:${RESET}"

if [ -n "$best_24_ch" ]; then
  if [ "$best_24_count" -eq 0 ]; then
    echo -e "  Canal ideal 2.4: ${GREEN}$best_24_ch — LIVRE${RESET}"
  else
    echo -e "  Canal ideal 2.4: ${GREEN}$best_24_ch ($best_24_count redes — menos congestionado)${RESET}"
  fi
fi

if [ -n "$best_5_ch" ]; then
  if [ "$best_5_count" -eq 0 ]; then
    echo -e "  Canal ideal 5G:  ${GREEN}$best_5_ch — LIVRE${RESET}"
  else
    echo -e "  Canal ideal 5G:  ${GREEN}$best_5_ch ($best_5_count redes — menos congestionado)${RESET}"
  fi
fi

echo "  ─────────────────────────────────"
echo ""
echo -e "  ${DIM}Acesse o painel do roteador (geralmente 192.168.1.1)${RESET}"
echo -e "  ${DIM}e altere o canal nas configuracoes de Wi-Fi.${RESET}"
echo ""
