#!/usr/bin/env bash

set -Eeuo pipefail

readonly SSH_AUTH_SOCKET="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/gcr/ssh"
readonly SSH_ASKPASS_BIN="/usr/lib/seahorse/ssh-askpass"
readonly SSH_DIR="${HOME}/.ssh"

info() {
  printf '\033[0;36m%s\033[0m\n' "$*"
}

warn() {
  printf '\033[0;33mWarning: %s\033[0m\n' "$*" >&2
}

die() {
  printf '\033[0;31mError: %s\033[0m\n' "$*" >&2
  exit 1
}

install_packages() {
  local -a packages=(openssh gcr-4 gnome-keyring libsecret seahorse)
  local -a missing=()
  local package

  for package in "${packages[@]}"; do
    pacman -Q "$package" >/dev/null 2>&1 || missing+=("$package")
  done

  ((${#missing[@]} == 0)) && return

  info "Installing SSH keyring packages: ${missing[*]}"
  if command -v omarchy >/dev/null 2>&1; then
    omarchy pkg add "${missing[@]}"
  else
    sudo pacman -S --needed --noconfirm "${missing[@]}"
  fi
}

enable_user_services() {
  info "Enabling the GNOME Keyring and GCR SSH agent"
  systemctl --user enable --now gnome-keyring-daemon.service
  systemctl --user enable --now gcr-ssh-agent.socket

  export SSH_AUTH_SOCK="$SSH_AUTH_SOCKET"
  systemctl --user set-environment SSH_AUTH_SOCK="$SSH_AUTH_SOCKET"

  if command -v dbus-update-activation-environment >/dev/null 2>&1 && [[ -n "${DBUS_SESSION_BUS_ADDRESS:-}" ]]; then
    dbus-update-activation-environment --systemd SSH_AUTH_SOCK
  fi
}

is_private_key() {
  local first_line

  [[ -f "$1" ]] || return 1
  IFS= read -r first_line <"$1" || return 1

  case "$first_line" in
    '-----BEGIN OPENSSH PRIVATE KEY-----' | \
      '-----BEGIN RSA PRIVATE KEY-----' | \
      '-----BEGIN DSA PRIVATE KEY-----' | \
      '-----BEGIN EC PRIVATE KEY-----' | \
      '-----BEGIN PRIVATE KEY-----' | \
      '-----BEGIN ENCRYPTED PRIVATE KEY-----') return 0 ;;
    *) return 1 ;;
  esac
}

run_with_askpass() {
  env \
    DISPLAY="${DISPLAY:-:0}" \
    SSH_ASKPASS="$SSH_ASKPASS_BIN" \
    SSH_ASKPASS_REQUIRE=force \
    setsid -w "$@" </dev/null
}

ensure_public_key() {
  local private_key="$1"
  local public_key="${private_key}.pub"
  local temporary_key

  [[ -s "$public_key" ]] && return 0

  info "Creating public key for $(basename "$private_key")"
  temporary_key="$(mktemp "${SSH_DIR}/.ssh-public-key.XXXXXX")"

  if run_with_askpass ssh-keygen -y -f "$private_key" >"$temporary_key"; then
    chmod 0644 "$temporary_key"
    mv -f "$temporary_key" "$public_key"
    return 0
  fi

  rm -f "$temporary_key"
  warn "Could not create ${public_key}; this key will be skipped."
  return 1
}

add_private_key() {
  local private_key="$1"

  [[ -L "$private_key" ]] || chmod 0600 "$private_key"
  ensure_public_key "$private_key" || return 1

  info "Adding $(basename "$private_key") to the keyring"
  if ! run_with_askpass ssh-add "$private_key"; then
    warn "Could not add ${private_key}."
    return 1
  fi
}

add_all_private_keys() {
  local private_key
  local failed=0
  local found=0

  if [[ -z "${DISPLAY:-}" && -z "${WAYLAND_DISPLAY:-}" ]]; then
    warn "No graphical session detected. Services were configured, but keys were not imported."
    warn "Run this script again from the desktop session to save their passphrases."
    return 0
  fi

  while IFS= read -r -d '' private_key; do
    is_private_key "$private_key" || continue
    found=1
    add_private_key "$private_key" || failed=1
  done < <(find "$SSH_DIR" -maxdepth 1 \( -type f -o -type l \) -print0)

  if ((found == 0)); then
    warn "No private SSH keys were found directly under ${SSH_DIR}."
  elif ((failed != 0)); then
    warn "Some keys could not be imported; see the messages above."
  fi
}

main() {
  [[ "$(uname -s)" == "Linux" ]] || die "This setup is only supported on Linux."
  [[ -f /etc/arch-release ]] || die "This setup is intended for Arch Linux."
  ((EUID != 0)) || die "Run this script as your regular user, not as root."
  command -v pacman >/dev/null 2>&1 || die "pacman was not found."
  command -v systemctl >/dev/null 2>&1 || die "systemctl was not found."

  install_packages

  command -v ssh-add >/dev/null 2>&1 || die "ssh-add was not installed."
  command -v ssh-keygen >/dev/null 2>&1 || die "ssh-keygen was not installed."
  [[ -x "$SSH_ASKPASS_BIN" ]] || die "Seahorse ssh-askpass was not installed."

  install -d -m 0700 "$SSH_DIR"
  enable_user_services
  add_all_private_keys

  info "SSH keyring setup completed. Open new terminals or log in again to refresh the environment."
}

main "$@"
