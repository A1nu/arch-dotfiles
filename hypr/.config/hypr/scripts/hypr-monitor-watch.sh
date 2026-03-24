#!/bin/bash
# hypr-monitor-watch.sh — distribute workspaces across monitors on hotplug
# Supports 3 configurations:
#   1. eDP-1 only:              1-9 on eDP-1
#   2. eDP-1 + DP:              DP gets 1,3,5,7,9 / eDP-1 gets 2,4,6,8
#   3. eDP-1 + DP + HDMI-A-1:   DP gets 1,4,7 / eDP-1 gets 2,5,8 / HDMI-A-1 gets 3,6,9

get_monitors() {
    hyprctl monitors -j | jq -r '.[].name'
}

has_monitor() {
    get_monitors | grep -q "^$1"
}

# Find the DP monitor name (DP-1, DP-2, DP-3, etc.)
get_dp() {
    get_monitors | grep "^DP-" | head -1
}

move_ws() {
    local ws="$1" monitor="$2"
    hyprctl dispatch moveworkspacetomonitor "$ws" "$monitor"
}

apply_layout() {
    local dp hdmi
    dp=$(get_dp)
    hdmi=""
    has_monitor "HDMI-A-1" && hdmi="HDMI-A-1"

    if [ -n "$dp" ] && [ -n "$hdmi" ]; then
        # 3 monitors: DP 1,4,7 / eDP-1 2,5,8 / HDMI-A-1 3,6,9
        move_ws 1 "$dp"
        move_ws 2 eDP-1
        move_ws 3 "$hdmi"
        move_ws 4 "$dp"
        move_ws 5 eDP-1
        move_ws 6 "$hdmi"
        move_ws 7 "$dp"
        move_ws 8 eDP-1
        move_ws 9 "$hdmi"
    elif [ -n "$dp" ]; then
        # 2 monitors (DP): DP 1,3,5,7,9 / eDP-1 2,4,6,8
        move_ws 1 "$dp"
        move_ws 2 eDP-1
        move_ws 3 "$dp"
        move_ws 4 eDP-1
        move_ws 5 "$dp"
        move_ws 6 eDP-1
        move_ws 7 "$dp"
        move_ws 8 eDP-1
        move_ws 9 "$dp"
    elif [ -n "$hdmi" ]; then
        # 2 monitors (HDMI): HDMI 1,3,5,7,9 / eDP-1 2,4,6,8
        move_ws 1 "$hdmi"
        move_ws 2 eDP-1
        move_ws 3 "$hdmi"
        move_ws 4 eDP-1
        move_ws 5 "$hdmi"
        move_ws 6 eDP-1
        move_ws 7 "$hdmi"
        move_ws 8 eDP-1
        move_ws 9 "$hdmi"
    else
        # Laptop only: all on eDP-1
        for ws in 1 2 3 4 5 6 7 8 9; do
            move_ws "$ws" eDP-1
        done
    fi
}

# Apply layout on startup
apply_layout

SOCK="/run/user/$(id -u)/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Reconnect loop: socat can die if Hyprland briefly drops the event socket
while true; do
    socat -u "UNIX-CONNECT:${SOCK}" - 2>/dev/null | while IFS= read -r line; do
        event="${line%%>>*}"
        data="${line#*>>}"
        data="${data%$'\r'}"

        case "$event" in
            monitoradded|monitorremoved)
                sleep 2
                apply_layout
                ;;
        esac
    done
    sleep 1
done
