#
# ~/.bashrc
#

for f in "$HOME/.config/shell/"*.sh; do
  [ -f "$f" ] || continue
  . "$f" || echo "Warning: failed to source $f" >&2
done
if [[ -z "$SSH_CONNECTION" ]] && [[ $(tty) != /dev/tty* ]] && [[ -z "$TMUX" ]] && [[ -z "$UTIL_TERM" ]]; then
  session_name=$(
    tmux list-sessions -F "#{session_name}:#{session_attached}" 2>/dev/null |
      awk -F: '$2 == 0 && $1 != "scratch" {print $1}' |
      while read -r name; do
        if tmux list-panes -t "$name" -F "#{pane_current_command}" |
          \grep -vqE '^(bash|zsh|fish)$'; then
          continue
        fi
        echo "$name"
        break
      done
  )
  if [[ -n $session_name ]]; then
    tmux attach -t $session_name
  else
    tmux
  fi
fi

export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
