#
# ~/.bash_profile
#
[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

if [[ -z "$SSH_CONNECTION" ]] && [[ -z "$DISPLAY" ]] && [[ $(tty) == /dev/tty1 ]]; then
  exec startx
fi
