#!/bin/bash
# install.sh — deploy system-level configs for devnull
# Run with sudo from the dotfiles repo root:
#   sudo bash system-devnull/install.sh
#
# Idempotent: safe to re-run.

set -e
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT_DIR="${DOTFILES_DIR}/system-devnull"

echo "==> Deploying system configs for devnull..."

# --- TLP drop-in ---
echo "--> TLP config"
install -Dm644 "${SCRIPT_DIR}/tlp/10-laptop.conf" /etc/tlp.d/10-laptop.conf
tlp start

# --- hypr-power script ---
echo "--> hypr-power.sh"
install -Dm755 "${SCRIPT_DIR}/scripts/hypr-power.sh" /usr/local/bin/hypr-power.sh

# --- udev rule ---
echo "--> udev rule"
install -Dm644 "${SCRIPT_DIR}/udev/99-hypr-power.rules" /etc/udev/rules.d/99-hypr-power.rules
udevadm control --reload-rules

echo ""
echo "==> Done. Remaining manual step:"
echo ""
echo "    Kernel sleep mode (systemd-boot):"
echo "    Edit /boot/loader/entries/arch.conf and append to the options line:"
echo "      mem_sleep_default=s2idle"
echo ""
echo "    Then: sudo bootctl update (if needed)"
echo ""
echo "    Verify after reboot:"
echo "      cat /sys/power/mem_sleep   # should show [s2idle]"
