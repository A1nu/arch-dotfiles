#!/bin/sh
set -eu

# Requires X running
if ! command -v xrandr >/dev/null 2>&1; then
  exit 0
fi

MONS="$(xrandr --query | awk '/ connected/{print $1}')"

has() { echo "$MONS" | grep -qx "$1"; }

# --- Desktop profile (your PC) ---
# DP-4 left, DP-2 center, DP-0 right, HDMI-0 extra
if has "DP-4" && has "DP-2" && has "DP-0"; then
  bspc monitor DP-4 -d 2 5 8
  bspc monitor DP-2 -d 1 4 7
  bspc monitor DP-0 -d 3 6 9
  if has "HDMI-0"; then
    bspc monitor HDMI-0 -d 10
  fi

  bspc config -m DP-4 top_padding 35
  bspc config -m DP-2 top_padding 35
  bspc config -m DP-0 top_padding 35
  [ "$(has HDMI-0 && echo yes || echo no)" = "yes" ] && bspc config -m HDMI-0 top_padding 35 || true
  exit 0
fi

# --- Laptop profile ---
# Prefer internal panel eDP-1 (or any eDP*)
EDP="$(echo "$MONS" | grep -E '^eDP' | head -n1 || true)"
if [ -n "${EDP:-}" ]; then
  bspc monitor "$EDP" -d 1 2 3 4 5 6 7 8 9 10
  bspc config -m "$EDP" top_padding 35
  exit 0
fi

# --- Generic fallback (if names differ) ---
# Put desktops on the first connected monitor
FIRST="$(echo "$MONS" | head -n1 || true)"
if [ -n "${FIRST:-}" ]; then
  bspc monitor "$FIRST" -d 1 2 3 4 5 6 7 8 9 10
  bspc config -m "$FIRST" top_padding 35
fi
