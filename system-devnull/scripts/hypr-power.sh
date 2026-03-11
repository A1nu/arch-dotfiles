#!/bin/bash
# hypr-power.sh — switch eDP-1 refresh rate based on AC/battery state
# Triggered by udev on power supply change events.
# Deployed to: /usr/local/bin/hypr-power.sh

USER_ID=1000
RUNTIME_DIR="/run/user/${USER_ID}"

# Find active Hyprland instance for this user
HYPR_SOCK=$(ls "${RUNTIME_DIR}/hypr/"*"/.socket.sock" 2>/dev/null | head -1)
[ -z "$HYPR_SOCK" ] && exit 0  # Hyprland not running

INSTANCE=$(basename "$(dirname "$HYPR_SOCK")")

AC=$(cat /sys/class/power_supply/AC0/online 2>/dev/null)

USERNAME=$(id -un "${USER_ID}")

if [ "$AC" = "1" ]; then
    REFRESH="120"
    brightnessctl set 25%+
    su -c "HYPRLAND_INSTANCE_SIGNATURE=${INSTANCE} hyprctl keyword monitor eDP-1,2880x1800@${REFRESH},0x0,2" \
        -s /bin/bash \
        "${USERNAME}"
else
    REFRESH="60"
    brightnessctl set 25%-
    su -c "HYPRLAND_INSTANCE_SIGNATURE=${INSTANCE} hyprctl keyword monitor eDP-1,2880x1800@${REFRESH},0x0,2" \
        -s /bin/bash \
        "${USERNAME}"
fi
