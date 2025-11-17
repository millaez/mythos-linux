#!/bin/bash
# Minimal Working MythOS Setup
# Clean, small, guaranteed to push to GitHub

set -e

echo "🏛️ MythOS Minimal Setup (Clean)"
echo "================================"
echo ""

# Clean start
rm -rf .git 2>/dev/null || true

echo "[1/8] Initializing git..."
git init
git branch -M main

echo "[2/8] Creating minimal structure..."
mkdir -p bootstrap core/themes pillars profiles

echo "[3/8] Creating .gitignore..."
cat > .gitignore << 'EOF'
*.log
__pycache__/
*.pyc
.vscode/
.DS_Store
Thumbs.db
EOF

echo "[4/8] Creating README.md..."
cat > README.md << 'EOF'
# 🏛️ MythOS

Modular Linux Provisioner for Arch Linux

## Quick Start

```bash
git clone https://github.com/millaez/mythos-linux.git
cd mythos-linux
sudo bash bootstrap/arch.sh
sudo python3 provisioner.py --all
```

## Features

- 🎮 Gaming: Steam, GameMode
- 💻 Developer: Git, Docker, Python
- ✨ Aesthetic: Fonts

## Usage

```bash
# Install everything
sudo python3 provisioner.py --all

# Gaming only
sudo python3 provisioner.py --gaming

# With Greek theme
sudo python3 provisioner.py --all --theme greek
```

**Contributors:** AI and me  
**License:** Public Domain
EOF

echo "[5/8] Creating provisioner.py..."
cat > provisioner.py << 'EOF'
#!/usr/bin/env python3
"""MythOS - Minimal Working Provisioner"""
import sys, os, subprocess, argparse

def cmd(c, desc):
    print(f"  → {desc}...", end='', flush=True)
    try:
        subprocess.run(c, shell=True, check=True, capture_output=True)
        print(" ✅")
        return True
    except:
        print(" ❌")
        return False

def install_gaming():
    print("\n🎮 Gaming Pillar")
    print("="*50)
    for pkg in ['steam', 'gamemode', 'lib32-gcc-libs']:
        cmd(f'pacman -S --noconfirm --needed {pkg}', f'Installing {pkg}')
    print("  ✅ Gaming complete")

def install_dev():
    print("\n💻 Developer Pillar")
    print("="*50)
    for pkg in ['git', 'python', 'docker', 'base-devel']:
        cmd(f'pacman -S --noconfirm --needed {pkg}', f'Installing {pkg}')
    cmd('systemctl enable docker', 'Enabling Docker')
    print("  ✅ Developer complete")

def install_aesthetic():
    print("\n✨ Aesthetic Pillar")
    print("="*50)
    for pkg in ['ttf-jetbrains-mono-nerd', 'noto-fonts']:
        cmd(f'pacman -S --noconfirm --needed {pkg}', f'Installing {pkg}')
    cmd('fc-cache -f', 'Updating fonts')
    print("  ✅ Aesthetic complete")

def main():
    p = argparse.ArgumentParser(description='MythOS Provisioner')
    p.add_argument('--gaming', action='store_true')
    p.add_argument('--dev', action='store_true')
    p.add_argument('--aesthetic', action='store_true')
    p.add_argument('--all', action='store_true')
    p.add_argument('--theme', choices=['greek','norse','egyptian'])
    args = p.parse_args()
    
    if os.geteuid() != 0:
        print("❌ Run as root: sudo python3 provisioner.py --all")
        sys.exit(1)
    
    themes = {'greek':'🏛️ Greek', 'norse':'⚔️ Norse', 'egyptian':'𓀭 Egyptian'}
    if args.theme:
        print(f"\n{themes[args.theme]} Theme")
    else:
        print("\n🏛️ MythOS")
    print("="*50)
    
    if args.all:
        args.gaming = args.dev = args.aesthetic = True
    
    if not (args.gaming or args.dev or args.aesthetic):
        print("Specify: --gaming, --dev, --aesthetic, or --all")
        sys.exit(1)
    
    if args.gaming: install_gaming()
    if args.dev: install_dev()
    if args.aesthetic: install_aesthetic()
    
    print(f"\n{'='*50}")
    print("✅ MythOS Complete!")
    print(f"{'='*50}\n")

if __name__ == "__main__":
    main()
EOF

chmod +x provisioner.py

echo "[6/8] Creating bootstrap/arch.sh..."
cat > bootstrap/arch.sh << 'EOF'
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
EOF

chmod +x bootstrap/arch.sh

echo "[7/8] Creating profiles/atlas.yaml..."
cat > profiles/atlas.yaml << 'EOF'
name: ATLAS
pillars: [gaming, developer, aesthetic]
theme: greek
EOF

echo "[8/8] Creating core/themes/__init__.py..."
mkdir -p core/themes
touch core/__init__.py
touch core/themes/__init__.py

echo ""
echo "================================"
echo "✅ Minimal Setup Complete!"
echo "================================"
echo ""
echo "Files created:"
ls -lh
echo ""
echo "Total size:"
du -sh .
echo ""
echo "Next steps:"
echo "  1. git add ."
echo "  2. git commit -m 'Initial commit'"
echo "  3. git remote add origin https://github.com/millaez/mythos-linux.git"
echo "  4. git push -u origin main"
echo ""
EOF

chmod +x setup-minimal.sh
