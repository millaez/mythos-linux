#!/bin/bash
# Install Hyprland tiling compositor

set -e

echo "🪟 Installing Hyprland..."

pacman -S --noconfirm --needed \
    hyprland \
    kitty \
    waybar \
    wofi \
    swaybg \
    swaylock \
    swayidle \
    grim \
    slurp \
    wl-clipboard

echo "✅ Hyprland installed"
echo "ℹ️  Run 'Hyprland' to start"
