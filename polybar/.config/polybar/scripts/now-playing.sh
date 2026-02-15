#!/usr/bin/env bash
# Show current playing track via playerctl (Spotify preferred).

set -euo pipefail

# Prefer spotify if available, otherwise any player
PLAYER="spotify"
if ! playerctl -p "$PLAYER" status &>/dev/null; then
  # Fall back to any player
  PLAYER="$(playerctl -l 2>/dev/null | head -n1 || true)"
fi

if [[ -z "${PLAYER:-}" ]]; then
  echo ""
  exit 0
fi

STATUS="$(playerctl -p "$PLAYER" status 2>/dev/null || true)"
if [[ "$STATUS" != "Playing" && "$STATUS" != "Paused" ]]; then
  echo ""
  exit 0
fi

TEXT="$(playerctl -p "$PLAYER" metadata --format '{{artist}} - {{title}}' 2>/dev/null || true)"
# Trim if too long
MAX=50
if ((${#TEXT} > MAX)); then
  TEXT="${TEXT:0:MAX}…"
fi

if [[ "$STATUS" == "Paused" ]]; then
  echo "⏸ ${TEXT}"
else
  echo "▶ ${TEXT}"
fi
