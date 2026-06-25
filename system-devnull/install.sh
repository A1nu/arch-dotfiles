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

# --- (removed) hypr-power.sh: AC/battery refresh switching moved to the user dotfile
#     ~/.config/hypr/scripts/hypr-refresh.sh (called by udev + hypr-monitor-watch.sh) ---
rm -f /usr/local/bin/hypr-power.sh

# --- udev rule ---
echo "--> udev rule"
install -Dm644 "${SCRIPT_DIR}/udev/99-hypr-power.rules" /etc/udev/rules.d/99-hypr-power.rules
udevadm control --reload-rules

# --- Remove deprecated clamshell-guard bits (no longer used) ---
echo "--> removing deprecated clamshell-guard (if present)"
systemctl disable --now clamshell-guard.service clamshell-inhibit.service 2>/dev/null || true
rm -f /etc/systemd/system/clamshell-guard.service \
      /etc/systemd/system/clamshell-inhibit.service \
      /usr/local/bin/clamshell-guard.sh
systemctl daemon-reload

# --- systemd sleep/lid drop-ins (suspend-then-hibernate) ---
echo "--> systemd logind + sleep drop-ins"
install -Dm644 "${SCRIPT_DIR}/systemd/logind-lid.conf"      /etc/systemd/logind.conf.d/10-lid-hibernate.conf
install -Dm644 "${SCRIPT_DIR}/systemd/sleep-hibernate.conf" /etc/systemd/sleep.conf.d/10-hibernate-delay.conf

# --- Disable USB/Thunderbolt as hibernate wake sources ---
echo "--> disable USB/Thunderbolt hibernate wake"
install -Dm644 "${SCRIPT_DIR}/systemd/disable-usb-hibernate-wake.service" /etc/systemd/system/disable-usb-hibernate-wake.service
systemctl daemon-reload
systemctl enable disable-usb-hibernate-wake.service

# --- Kernel cmdline (UKI): NVMe sleep-drain fix + hibernate resume device ---
# Samsung 990 draws ~4W in s2idle via broken "Simple Suspend"; nvme.noacpi=1 -> ~1.4W (TUXEDO Gen9 FAQ).
# resume= points at the encrypted swap LV (already unlocked by the encrypt+lvm2 hooks at boot).
echo "--> kernel cmdline (/etc/kernel/cmdline)"
CMDLINE=/etc/kernel/cmdline
SWAP_DEV=/dev/vg0/lv_swap
cp -n "$CMDLINE" "${CMDLINE}.bak"   # one-time backup
grep -q 'nvme.noacpi=1' "$CMDLINE" || sed -i 's/$/ nvme.noacpi=1/' "$CMDLINE"
if [ -e "$SWAP_DEV" ]; then
  SWAP_UUID="$(blkid -o value -s UUID "$SWAP_DEV")"
  grep -q 'resume=' "$CMDLINE" || sed -i "s#\$# resume=UUID=${SWAP_UUID}#" "$CMDLINE"
else
  echo "    WARNING: $SWAP_DEV not found — skipped resume= (hibernate will not work)"
fi

# --- mkinitcpio: add 'resume' hook after lvm2 (needed for hibernate) ---
echo "--> mkinitcpio HOOKS (resume)"
cp -n /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak   # one-time backup
grep -qE '^HOOKS=.*\bresume\b' /etc/mkinitcpio.conf || \
  sed -i '/^HOOKS=/ s/\blvm2\b/lvm2 resume/' /etc/mkinitcpio.conf

# --- Rebuild UKI (bakes in the new cmdline + initramfs hooks) ---
echo "--> rebuilding initramfs/UKI (mkinitcpio -p linux)"
mkinitcpio -p linux

echo ""
echo "==> Done. Reboot required for the cmdline + initramfs changes to take effect."
echo ""
echo "    Verify after reboot:"
echo "      cat /proc/cmdline        # contains nvme.noacpi=1 and resume=UUID=..."
echo "      cat /sys/power/mem_sleep # [s2idle]"
echo "      cat /sys/power/resume    # non-zero (swap device maj:min)"
echo ""
echo "    TEST HIBERNATE before relying on it:"
echo "      sudo systemctl hibernate   # powers fully off; power back on -> session restored"
echo "      (if it boots fresh instead of restoring your session, hibernate is NOT working)"
echo ""
echo "    Then test the lid: unplug AC, close lid, wait >10 min -> machine should be"
echo "    powered off (hibernated), and reopening should restore your session."
