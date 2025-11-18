#!/bin/bash
set -e

# MythOS Bootstrap — Arch Base System Setup
# This script assumes you're running on a fresh Arch install or post-archinstall

echo "🜁 MythOS Bootstrap — Arch Base System"
echo "======================================="

# Update system
echo "📦 Updating system packages..."
sudo pacman -Syu --noconfirm

# Install essential base packages
echo "📦 Installing base packages..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    git \
    wget \
    curl \
    vim \
    neovim \
    htop \
    btop \
    fastfetch \
    unzip \
    zip \
    man-db \
    man-pages \
    rsync

# Install yay (AUR helper) if not present
if ! command -v yay &> /dev/null; then
    echo "📦 Installing yay (AUR helper)..."
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ~
fi

# Enable multilib (for 32-bit support, needed for gaming)
echo "📦 Enabling multilib repository..."
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo -e "\n[multilib]\nInclude = /etc/pacman.d/mirrorlist" | sudo tee -a /etc/pacman.conf
    sudo pacman -Sy
fi

# Install common utilities
echo "📦 Installing common utilities..."
sudo pacman -S --needed --noconfirm \
    bash-completion \
    fd \
    ripgrep \
    bat \
    eza \
    zoxide \
    fzf \
    stow

# Set up dotfiles directory structure
echo "📁 Creating dotfiles structure..."
mkdir -p ~/.config
mkdir -p ~/repos
mkdir -p ~/.local/bin

# Basic shell improvements
echo "🐚 Setting up shell improvements..."
if ! grep -q "alias ls='eza'" ~/.bashrc 2>/dev/null; then
    cat >> ~/.bashrc << 'EOF'

# MythOS Shell Enhancements
alias ls='eza --icons'
alias ll='eza -la --icons'
alias cat='bat'
alias find='fd'
alias grep='rg'
eval "$(zoxide init bash)"
EOF
fi

echo "✅ Arch base system bootstrap complete!"
echo "💡 Next: Run provisioner with --gaming, --dev, or --aesthetic flags"
