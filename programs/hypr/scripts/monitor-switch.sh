#!/bin/bash
INTERNAL_RES="3840x2400@60.00"
INTERNAL_SCALE="2"
INTERNAL_POS="0x0"
INTERNAL="eDP-1"

has_external() {
  hyprctl monitors -j | jq -r '.[].name' | grep -qv "^${INTERNAL}$"
}

enable_internal() {
  hyprctl keyword monitor "$INTERNAL, $INTERNAL_RES, $INTERNAL_POS, $INTERNAL_SCALE"
}

disable_internal() {
  hyprctl keyword monitor "$INTERNAL, disable"
}

apply_monitor_rules() {
  if has_external; then
    disable_internal
  else
    enable_internal
  fi
}

apply_monitor_rules

SOCKET="$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock"

# Reconnect loop: socat exits when Hyprland resets the IPC socket on monitor events
while true; do
  socat - UNIX-CONNECT:"$SOCKET" 2>/dev/null | while IFS= read -r line; do
    event="${line%%>>*}"
    data="${line##*>>}"
    case "$event" in
      monitoradded)
        [ "$data" != "$INTERNAL" ] && sleep 0.5 && disable_internal
        ;;
      monitorremoved)
        if [ "$data" != "$INTERNAL" ]; then
          sleep 1
          has_external || enable_internal
        fi
        ;;
    esac
  done
  sleep 1
done
