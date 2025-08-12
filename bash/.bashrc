#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

for f in "$HOME/.config/shell/"*.sh; do
  [ -f "$f" ] || continue
  . "$f" || echo "Warning: failed to source $f" >&2
done
