#!/bin/bash
# hypr-monitor-watch.sh — distribute workspaces across monitors on hotplug
# Supports configurations:
#   1. eDP-1 only:                    1-9 on eDP-1
#   2. eDP-1 + 1 external:           ext 1,3,5,7,9 / eDP-1 2,4,6,8
#   3. eDP-1 + 2 externals:          ext1 1,4,7 / eDP-1 2,5,8 / ext2 3,6,9
# External monitors: any combination of DP-* and HDMI-A-*

get_monitors() {
    hyprctl monitors -j | jq -r '.[].name'
}

# Collect external monitors (everything except eDP-1), sorted for consistency
get_externals() {
    get_monitors | grep -v "^eDP-" | sort
}

apply_layout() {
    local -a ext ws_monitor
    mapfile -t ext < <(get_externals)
    local n=${#ext[@]}

    # Build workspace-to-monitor mapping (index 1-9)
    if [ "$n" -ge 2 ]; then
        # 3 monitors: ext[0] 1,4,7 / eDP-1 2,5,8 / ext[1] 3,6,9
        ws_monitor=(_ "${ext[0]}" eDP-1 "${ext[1]}" "${ext[0]}" eDP-1 "${ext[1]}" "${ext[0]}" eDP-1 "${ext[1]}")
    elif [ "$n" -eq 1 ]; then
        # 2 monitors: ext 1,3,5,7,9 / eDP-1 2,4,6,8
        ws_monitor=(_ "${ext[0]}" eDP-1 "${ext[0]}" eDP-1 "${ext[0]}" eDP-1 "${ext[0]}" eDP-1 "${ext[0]}")
    else
        # Laptop only
        ws_monitor=(_ eDP-1 eDP-1 eDP-1 eDP-1 eDP-1 eDP-1 eDP-1 eDP-1 eDP-1)
    fi

    # Clear stale workspace rules (keyword workspace appends, never replaces)
    hyprctl reload
    sleep 1

    # Set monitor binding rules for future workspace creation
    local batch=""
    for ws in 1 2 3 4 5 6 7 8 9; do
        batch+="keyword workspace $ws, monitor:${ws_monitor[$ws]};"
    done
    hyprctl --batch "$batch"

    # Move existing workspaces to their target monitors
    batch=""
    for ws in 1 2 3 4 5 6 7 8 9; do
        batch+="dispatch moveworkspacetomonitor $ws ${ws_monitor[$ws]};"
    done
    hyprctl --batch "$batch"
}

# Apply layout on startup
apply_layout

SOCK="/run/user/$(id -u)/hypr/${HYPRLAND_INSTANCE_SIGNATURE}/.socket2.sock"

# Reconnect loop: socat can die if Hyprland briefly drops the event socket
while true; do
    socat -u "UNIX-CONNECT:${SOCK}" - 2>/dev/null | while IFS= read -r line; do
        event="${line%%>>*}"

        case "$event" in
            monitoradded|monitorremoved)
                # Debounce: drain all events for 3s after the last monitor change
                while IFS= read -r -t 3 line; do :; done
                apply_layout
                ;;
        esac
    done
    sleep 1
done
