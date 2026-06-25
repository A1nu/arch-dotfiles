#!/bin/bash
# hypr-idle-dpms.sh — on idle, power off displays UNLESS docked.
#
# Called from the DPMS-off hypridle listener (devnull-idle.conf, timeout 480).
# When an external (non-eDP) display is connected we KEEP DPMS on: blanking the
# panels while docked leaves the dock to drift into its UCSI drop, which has
# crashed the compositor. Dim (180s) and lock (300s) are separate listeners and
# still fire — only the DPMS-off step is skipped while docked.

external_connected() {
  local s
  for s in /sys/class/drm/*/status; do
    [[ "$s" == *eDP* ]] && continue                      # skip the internal panel
    [[ "$(cat "$s" 2>/dev/null)" == "connected" ]] && return 0
  done
  return 1
}

if external_connected; then
  exit 0                                                 # docked: leave displays powered
fi

hyprctl dispatch dpms off && brightnessctl -d white:kbd_backlight s 0
