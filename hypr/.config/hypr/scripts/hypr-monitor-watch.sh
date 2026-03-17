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

SOCK="/run/user/$(id -u)/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

socat - "UNIX-CONNECT:${SOCK}" | while IFS= read -r line; do
    event="${line%%>>*}"
    data="${line#*>>}"

    case "$event" in
        monitoradded)
            # data is the monitor name e.g. "DP-1"
            sleep 1  # give Hyprland a moment to fully register the monitor
            move_to_monitor "$data"
            ;;
        monitorremoved)
            move_to_laptop
            ;;
    esac
done
