#!/bin/bash
set -e

# F.O.R.G.E. Gaming Pillar — Steam Setup
# Part of: forge-arch

echo "🎮 Installing Steam and dependencies..."

# Determine target user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
fi

# Detect GPU vendor
detect_gpu() {
    if lspci | grep -qi "nvidia"; then
        echo "nvidia"
    elif lspci | grep -qiE "amd|radeon"; then
        echo "amd"
    elif lspci | grep -qi "intel.*graphics"; then
        echo "intel"
    else
        echo "unknown"
    fi
}

GPU_VENDOR=$(detect_gpu)
echo "🔍 Detected GPU: $GPU_VENDOR"

# Install base Steam package
sudo pacman -S --needed --noconfirm steam

# Install GPU-specific 32-bit libraries for Steam
case "$GPU_VENDOR" in
    nvidia)
        echo "📦 Installing NVIDIA 32-bit libraries..."
        sudo pacman -S --needed --noconfirm \
            lib32-nvidia-utils \
            lib32-vulkan-icd-loader
        ;;
    amd)
        echo "📦 Installing AMD 32-bit libraries..."
        sudo pacman -S --needed --noconfirm \
            lib32-mesa \
            lib32-vulkan-radeon \
            lib32-vulkan-icd-loader
        ;;
    intel)
        echo "📦 Installing Intel 32-bit libraries..."
        sudo pacman -S --needed --noconfirm \
            lib32-mesa \
            lib32-vulkan-intel \
            lib32-vulkan-icd-loader
        ;;
    *)
        echo "⚠️  Unknown GPU vendor, installing generic Vulkan loader..."
        sudo pacman -S --needed --noconfirm \
            lib32-mesa \
            lib32-vulkan-icd-loader
        ;;
esac

# Install Proton dependencies (Wine)
echo "📦 Installing Wine and Proton dependencies..."
sudo pacman -S --needed --noconfirm \
    wine-staging \
    wine-mono \
    wine-gecko \
    winetricks \
    lib32-gcc-libs \
    lib32-glibc

# Create Steam library directory
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/Games/SteamLibrary"

echo "✅ Steam installation complete!"
echo "💡 Launch Steam and log in"
echo "💡 Enable Proton in Settings > Compatibility > Enable Steam Play for all titles"
echo "💡 Recommended: Set Proton Experimental as default"
