#!/usr/bin/env bash
# Show bluetooth power state and whether any device is connected.
# If you want to detect "headphones", you can match by name substring.

set -euo pipefail

# Check if bluetoothctl works
if ! command -v bluetoothctl &>/dev/null; then
  echo "BT:na"
  exit 0
fi

POWERED="$(bluetoothctl show 2>/dev/null | awk -F': ' '/Powered:/ {print $2; exit}' || true)"
if [[ "$POWERED" != "yes" ]]; then
  echo "BT:off"
  exit 0
fi

# Connected devices (works on newer bluez)
CONNECTED="$(bluetoothctl devices Connected 2>/dev/null | sed -n 's/^Device [0-9A-F:]\+ //p' || true)"

if [[ -z "${CONNECTED:-}" ]]; then
  echo "BT:on"
  exit 0
fi

# If you want to specifically detect headphones, tune this regex:
# e.g. "Arctis|Sony|Bose|WH-"
HP_REGEX="${HP_REGEX:-Arctis|Nova|Head|WH-|Bose|Sony}"
if echo "$CONNECTED" | grep -Eq "$HP_REGEX"; then
  echo "BT:hp"
else
  echo "BT:con"
fi
