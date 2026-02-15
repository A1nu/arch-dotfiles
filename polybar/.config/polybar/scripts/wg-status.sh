#!/usr/bin/env bash
# Show WireGuard status for a given interface (default: wg-home)

set -euo pipefail

IFACE="${1:-wg-home}"

if ! ip link show "$IFACE" &>/dev/null; then
  echo "WG:down"
  exit 0
fi

# Check recent handshake (optional but useful)
# If wg is not present or handshake missing, just show "up".
if command -v wg &>/dev/null; then
  HS="$(wg show "$IFACE" latest-handshakes 2>/dev/null | awk '{print $2}' | head -n1 || true)"
  NOW="$(date +%s)"
  if [[ -n "${HS:-}" && "$HS" != "0" ]]; then
    AGE=$((NOW - HS))
    # Consider "active" if handshake was within last 180s
    if ((AGE <= 180)); then
      echo "WG:up"
    else
      echo "WG:idle"
    fi
  else
    echo "WG:up"
  fi
else
  echo "WG:up"
fi
