#!/bin/sh
# Show /mnt/storage usage only if mounted
if findmnt -rn /mnt/storage >/dev/null 2>&1; then
  # %used
  USED="$(df -hP /mnt/storage | awk 'NR==2{print $5}')"
  printf "%%{F#F0C674}Storage:%%{F-} %s\n" "$USED"
else
  # Print nothing (polybar will hide if empty in most setups; if not, print a short placeholder)
  printf ""
fi
