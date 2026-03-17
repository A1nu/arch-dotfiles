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

# Preserve current eDP-1 position so external monitor layout is not disrupted
EDP_POS=$(su -c "HYPRLAND_INSTANCE_SIGNATURE=${INSTANCE} hyprctl monitors -j" -s /bin/bash "${USERNAME}" \
    | jq -r '.[] | select(.name == "eDP-1") | "\(.x)x\(.y)"')
EDP_POS="${EDP_POS:-0x0}"

if [ "$AC" = "1" ]; then
    REFRESH="120"
    brightnessctl set 25%+
else
    REFRESH="60"
    brightnessctl set 25%-
fi

su -c "HYPRLAND_INSTANCE_SIGNATURE=${INSTANCE} hyprctl keyword monitor eDP-1,2880x1800@${REFRESH},${EDP_POS},1.25" \
    -s /bin/bash \
    "${USERNAME}"
