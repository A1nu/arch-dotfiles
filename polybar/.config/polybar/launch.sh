#!/usr/bin/env bash
killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.3; done

MONITOR=DP-2 polybar --reload -l info main &
MONITOR=DP-4 polybar --reload -l info secondary &
MONITOR=DP-0 polybar --reload -l info secondary &
