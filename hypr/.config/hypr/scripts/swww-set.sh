#!/usr/bin/env bash
# Purpose: start swww-daemon (if not running) and set a static wallpaper on all outputs.
# Usage: swww-set.sh [path-to-image]; if omitted, uses $HOME/Pictures/wallpapers/default.jpg

set -euo pipefail

WALL="${1:-$HOME/Pictures/wallpapers/anime-girl-3840x2160-14871.jpeg}"

# Start daemon if it's not running
if ! pgrep -x swww-daemon >/dev/null 2>&1; then
  # --no-cache avoids stale buffers; safe for static wallpapers
  swww-daemon --no-cache &
  # Wait until the socket is ready
  for _ in $(seq 1 50); do
    if swww query >/dev/null 2>&1; then break; fi
    sleep 0.05
  done
fi

# Apply wallpaper to every connected monitor (parse names from `hyprctl monitors`)
# Example names: DP-1, HDMI-A-1, eDP-1
hyprctl monitors \
  | awk '/^Monitor / {print $2}' \
  | while read -r OUT; do
      # No animation for zero GPU overhead
      swww img "$WALL" --transition-type none --outputs "$OUT"
    done

