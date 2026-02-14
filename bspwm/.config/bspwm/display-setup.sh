#!/bin/sh
set -eu

# Try autorandr first (handles dock/undock profiles)
if command -v autorandr >/dev/null 2>&1; then
  autorandr --change --force 2>/dev/null || true
fi

# Give X a moment to settle
sleep 0.2

# Detect monitors known to Xrandr
MONITORS="$(xrandr --query | awk '/ connected/{print $1}')"

# Helper: set desktops for a monitor only if it exists
set_desktops() {
  m="$1"
  shift
  echo "$MONITORS" | grep -qx "$m" || return 0
  bspc monitor "$m" -d "$@"
}

# Laptop internal panel is usually eDP-1 (sometimes eDP-1-1)
# We'll pick the first connected eDP* if present.
EDP="$(echo "$MONITORS" | grep -E '^eDP' | head -n1 || true)"

# If we have an internal display, use it as baseline
if [ -n "${EDP:-}" ]; then
  # Undocked default: 1..10 on internal display
  bspc monitor "$EDP" -d 1 2 3 4 5 6 7 8 9 10
fi

# If external monitors exist, you can map desktops across them.
# Adjust names once you know your actual connector names (DP-1, HDMI-1, etc.)
# Example: first external gets 1..5, internal gets 6..10
EXT="$(echo "$MONITORS" | grep -vE '^eDP' | head -n1 || true)"
if [ -n "${EDP:-}" ] && [ -n "${EXT:-}" ]; then
  set_desktops "$EDP" 1 3 5 7 9
  set_desktops "$EXT" 2 4 6 8 10
fi

# Apply top padding for polybar to all connected monitors
for m in $MONITORS; do
  bspc config -m "$m" top_padding 35
done
