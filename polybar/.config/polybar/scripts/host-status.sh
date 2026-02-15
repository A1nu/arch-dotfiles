#!/usr/bin/env bash
# Ping a host and print a short status label.

set -euo pipefail

LABEL="${1:?label required}"
HOST="${2:?host required}"
TIMEOUT="${3:-1}"

if ping -c 1 -W "$TIMEOUT" "$HOST" &>/dev/null; then
  echo "${LABEL}:up"
else
  echo "${LABEL}:down"
fi
