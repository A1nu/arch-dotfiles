#!/usr/bin/env bash
# Check TCP port reachability using nc and print LABEL:up/down

set -euo pipefail

LABEL="${1:?label required}"
HOST="${2:?host required}"
PORT="${3:?port required}"
TIMEOUT="${4:-2}"

if nc -vz -w "$TIMEOUT" "$HOST" "$PORT" &>/dev/null; then
  echo "${LABEL}:up"
else
  echo "${LABEL}:down"
fi
