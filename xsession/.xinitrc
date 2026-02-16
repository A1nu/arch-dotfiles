#!/bin/sh
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -r "$f" ] && . "$f"
  done
fi
[ -f "$HOME/.xprofile" ] && . "$HOME/.xprofile"

export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=BSPWM
export DESKTOP_SESSION=bspwm

[ -f "$HOME/.Xresources" ] && xrdb -merge "$HOME/.Xresources"

HOST="$(/usr/bin/hostname)"
if [ "$HOST" = "arch-DESKTOP" ]; then
  xrandr --output DP-4 --mode 2560x1440 --rate 165 --pos 0x0 --rotate normal \
    --output DP-2 --primary --mode 2560x1440 --rate 240 --pos 2560x0 --rotate normal \
    --output DP-0 --mode 2560x1440 --rate 165 --pos 5120x0 --rotate normal \
    --output HDMI-0 --auto --right-of DP-0
fi

systemctl --user import-environment \
  DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_RUNTIME_DIR \
  XDG_SESSION_ID XDG_SEAT XDG_VTNR

dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_RUNTIME_DIR \
  XDG_SESSION_ID XDG_SEAT XDG_VTNR
systemctl --user start xsession.target

bspwm

systemctl --user stop xsession.target
