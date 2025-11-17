#!/bin/bash
# Install Proton-GE for better game compatibility

set -e

echo "🎮 Installing Proton-GE..."

COMPAT_DIR="$HOME/.steam/root/compatibilitytools.d"
mkdir -p "$COMPAT_DIR"

# Get latest Proton-GE
LATEST_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | \
    grep "browser_download_url.*tar.gz" | \
    cut -d '"' -f 4)

if [ -n "$LATEST_URL" ]; then
    echo "Downloading latest Proton-GE..."
    curl -L "$LATEST_URL" -o /tmp/proton-ge.tar.gz
    tar -xzf /tmp/proton-ge.tar.gz -C "$COMPAT_DIR"
    rm /tmp/proton-ge.tar.gz
    echo "✅ Proton-GE installed"
else
    echo "❌ Could not fetch Proton-GE"
fi
