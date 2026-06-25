#!/bin/bash
# hypr-refresh.sh — set eDP-1 refresh by AC state: 120Hz on AC, 60Hz on battery.
# Scale + position are preserved (so docked layouts aren't disturbed).
#
# Runs both in-session (called from hypr-monitor-watch.sh) and from udev on AC change
# (via `runuser -u a1nu -- ...`). It derives XDG_RUNTIME_DIR + the Hyprland instance
# itself — the old hypr-power.sh failed because it never set XDG_RUNTIME_DIR for hyprctl.

export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
SOCK=$(ls "$XDG_RUNTIME_DIR/hypr/"*/.socket.sock 2>/dev/null | head -1)
[ -z "$SOCK" ] && exit 0   # Hyprland not running
export HYPRLAND_INSTANCE_SIGNATURE="$(basename "$(dirname "$SOCK")")"

if [ "$(cat /sys/class/power_supply/AC0/online 2>/dev/null || echo 1)" = 1 ]; then
  HZ=120
else
  HZ=60
fi

# Preserve current eDP-1 position + scale
read -r POS SCALE < <(hyprctl monitors -j | jq -r '.[]|select(.name=="eDP-1")|"\(.x)x\(.y) \(.scale)"')
hyprctl keyword monitor "eDP-1,2880x1800@${HZ},${POS:-0x0},${SCALE:-1.5}"
