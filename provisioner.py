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
