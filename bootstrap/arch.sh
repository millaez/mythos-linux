#!/bin/bash
set -euo pipefail
echo "🏛️ MythOS Bootstrap"
echo "===================="

if [ "$EUID" -ne 0 ]; then
    echo "❌ Run as root: sudo bash bootstrap/arch.sh"
    exit 1
fi

echo "[1/5] Updating system..."
pacman -Syu --noconfirm

echo "[2/5] Installing dependencies..."
pacman -S --noconfirm base-devel git python wget curl

echo "[3/5] Enabling multilib..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
    pacman -Sy
fi

echo "[4/5] Installing yay..."
if ! command -v yay &>/dev/null && [ -n "${SUDO_USER:-}" ]; then
    sudo -u "$SUDO_USER" bash << 'EOY'
cd /tmp
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si --noconfirm
EOY
fi

echo "[5/5] Optimizing pacman..."
sed -i 's/#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf

echo ""
echo "✅ Bootstrap complete!"
echo ""
echo "Next: sudo python3 provisioner.py --all"
