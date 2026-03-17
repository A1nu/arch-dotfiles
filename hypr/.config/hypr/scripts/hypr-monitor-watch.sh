#!/bin/bash
# hypr-monitor-watch.sh — move even workspaces to external monitor on hotplug
# Listens to Hyprland's event socket. Deployed via stow (hypr package).

EVEN_WORKSPACES=(2 4 6 8 10)

move_to_monitor() {
    local monitor="$1"
    for ws in "${EVEN_WORKSPACES[@]}"; do
        hyprctl dispatch moveworkspacetomonitor "$ws" "$monitor"
    done
}

move_to_laptop() {
    for ws in "${EVEN_WORKSPACES[@]}"; do
        hyprctl dispatch moveworkspacetomonitor "$ws" eDP-1
    done
}

# On startup: if an external monitor is already connected, move workspaces now
external=$(hyprctl monitors -j | jq -r '.[] | select(.name != "eDP-1") | .name' | head -1)
if [ -n "$external" ]; then
    move_to_monitor "$external"
fi

SOCK="/run/user/$(id -u)/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Reconnect loop: socat can die if Hyprland briefly drops the event socket
while true; do
    socat -u "UNIX-CONNECT:${SOCK}" - 2>/dev/null | while IFS= read -r line; do
        event="${line%%>>*}"
        data="${line#*>>}"
        data="${data%$'\r'}"  # strip trailing carriage return

        case "$event" in
            monitoradded)
                sleep 2  # give Hyprland time to finish auto-placement
                move_to_monitor "$data"
                ;;
            monitorremoved)
                move_to_laptop
                ;;
        esac
    done
    sleep 1
done
