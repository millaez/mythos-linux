#!/bin/bash
# Install distrobox for containerized dev environments

set -e

echo "📦 Installing distrobox..."

sudo pacman -S --noconfirm --needed distrobox podman

# Create default containers
if [ -n "$SUDO_USER" ]; then
    sudo -u "$SUDO_USER" distrobox create --name ubuntu-dev --image ubuntu:22.04
    sudo -u "$SUDO_USER" distrobox create --name fedora-dev --image fedora:39
fi

echo "✅ distrobox installed"
