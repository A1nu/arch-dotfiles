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

systemctl --user import-environment \
  DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_RUNTIME_DIR \
  XDG_SESSION_ID XDG_SEAT XDG_VTNR

dbus-update-activation-environment --systemd \
  DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_RUNTIME_DIR \
  XDG_SESSION_ID XDG_SEAT XDG_VTNR
systemctl --user start xsession.target
trap 'systemctl --user stop xsession.target' EXIT INT TERM

bspwm
