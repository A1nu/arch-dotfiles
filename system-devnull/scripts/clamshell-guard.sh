#!/bin/bash
# clamshell-guard.sh — clamshell (lid closed, stay awake) ONLY on AC + external display.
#
# logind has no power-aware "docked" handler, so with HandleLidSwitchDocked=suspend-then-hibernate
# the lid normally sleeps even when docked. This guard holds a handle-lid-switch block inhibitor
# (clamshell-inhibit.service) while BOTH conditions hold:
#   - on AC power, AND
#   - at least one external (non-eDP) display is connected.
# Otherwise it drops the inhibitor, so closing the lid on battery sleeps as configured.
#
# Triggered by udev on AC and DRM (monitor hotplug) changes, and once at boot.

ac_online() { [[ "$(cat /sys/class/power_supply/AC0/online 2>/dev/null)" == "1" ]]; }

external_connected() {
  local s
  for s in /sys/class/drm/*/status; do
    [[ "$s" == *eDP* ]] && continue                       # skip the internal panel
    [[ "$(cat "$s" 2>/dev/null)" == "connected" ]] && return 0
  done
  return 1
}

if ac_online && external_connected; then
  systemctl --no-block start clamshell-inhibit.service
else
  systemctl --no-block stop clamshell-inhibit.service
fi
