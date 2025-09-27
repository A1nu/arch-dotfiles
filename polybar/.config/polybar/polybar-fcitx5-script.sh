#!/usr/bin/env bash
name="$(fcitx5-remote -n 2>/dev/null || echo)"
case "$name" in
keyboard-us) echo "US" ;;
keyboard-ru) echo "RU" ;;
*) echo "${name:---}" ;; # например rime/pinyin и т.п.
esac
