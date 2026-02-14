#!/bin/sh
set -eu

pkill -x polybar >/dev/null 2>&1 || true
while pgrep -x polybar >/dev/null 2>&1; do sleep 0.2; done

# Pick primary monitor (fallback to first connected)
PRIMARY="$(xrandr --query | awk '/ connected primary/{print $1; exit}')"
[ -n "${PRIMARY:-}" ] || PRIMARY="$(xrandr --query | awk '/ connected/{print $1; exit}')"

for m in $(xrandr --query | awk '/ connected/{print $1}'); do
  if [ "$m" = "$PRIMARY" ]; then
    MONITOR="$m" polybar --reload main &
  else
    MONITOR="$m" polybar --reload secondary &
  fi
done
