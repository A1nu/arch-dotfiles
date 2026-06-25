#!/usr/bin/env bash
# nchat file_picker_command wrapper (set in ~/.config/nchat/ui.conf).
# If the clipboard holds a path to an existing file (e.g. from the Super+Ctrl+5
# screenshot bind that copies a file path), select it directly. Otherwise fall
# back to yazi for interactive browsing.
# nchat passes the temp output file as $1; we write the chosen path into it.
out="$1"
clip="$(wl-paste 2>/dev/null)"
if [ -f "$clip" ]; then
  printf '%s\n' "$clip" > "$out"
else
  yazi --chooser-file="$out"
fi
