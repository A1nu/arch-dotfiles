#!/usr/bin/env bash
# Region-select a screenshot, save to a temp dir, copy the FILE PATH to clipboard.
# For pasting image paths into TUI chat clients (wee-slack /slack upload, nchat Ctrl-t).
set -euo pipefail

dir="${TMPDIR:-/tmp}/hypr-shots"
mkdir -p "$dir"
file="$dir/shot-$(date +%Y%m%d-%H%M%S).png"

geom=$(slurp) || exit 0          # abort cleanly if selection cancelled
grim -g "$geom" "$file"
wl-copy "$file"

command -v notify-send >/dev/null && notify-send "Screenshot saved" "$file (path copied)"
