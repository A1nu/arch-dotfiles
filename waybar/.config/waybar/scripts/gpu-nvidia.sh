#!/usr/bin/env bash
# Outputs {"usage":<int>,"temp":<int>} using nvidia-smi
read -r UTIL TEMP < <(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits 2>/dev/null | head -n1 | tr -d ' %')
# Fallback if nvidia-smi not ready
if [ -z "$UTIL" ] || [ -z "$TEMP" ]; then
  echo '{"usage":0,"temp":0}'
  exit 0
fi
echo "{\"usage\":$UTIL,\"temp\":$TEMP}"
