#!/bin/bash
set -e

# MythOS Gaming Pillar — Lutris Setup

echo "🎮 Installing Lutris and runners..."

# Install Lutris
sudo pacman -S --needed --noconfirm \
    lutris

# Install Wine dependencies
sudo pacman -S --needed --noconfirm \
    wine-staging \
    giflib \
    lib32-giflib \
    libpng \
    lib32-libpng \
    libldap \
    lib32-libldap \
    gnutls \
    lib32-gnutls \
    mpg123 \
    lib32-mpg123 \
    openal \
    lib32-openal \
    v4l-utils \
    lib32-v4l-utils \
    libpulse \
    lib32-libpulse \
    alsa-plugins \
    lib32-alsa-plugins \
    alsa-lib \
    lib32-alsa-lib \
    libjpeg-turbo \
    lib32-libjpeg-turbo \
    libxcomposite \
    lib32-libxcomposite \
    libxinerama \
    lib32-libxinerama \
    ncurses \
    lib32-ncurses \
    ocl-icd \
    lib32-ocl-icd \
    libxslt \
    lib32-libxslt \
    libva \
    lib32-libva \
    gtk3 \
    lib32-gtk3 \
    gst-plugins-base-libs \
    lib32-gst-plugins-base-libs \
    vulkan-icd-loader \
    lib32-vulkan-icd-loader

# Create Lutris games directory
mkdir -p ~/Games/Lutris

echo "✅ Lutris installed!"
echo "💡 Launch Lutris to install game runners"
echo "💡 Recommended: Install wine-ge-custom from Lutris settings"
