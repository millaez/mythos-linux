#!/bin/bash
# Install Proton-GE for better game compatibility

set -e

echo "🎮 Installing Proton-GE..."

# Get the user who will use Steam
if [ -n "$SUDO_USER" ]; then
    STEAM_USER="$SUDO_USER"
else
    STEAM_USER="$USER"
fi

# Run as the actual user (not root)
sudo -u "$STEAM_USER" bash << 'INNEREOF'
COMPAT_DIR="$HOME/.steam/root/compatibilitytools.d"
mkdir -p "$COMPAT_DIR"

echo "  → Fetching latest Proton-GE release..."
LATEST_URL=$(curl -s https://api.github.com/repos/GloriousEggroll/proton-ge-custom/releases/latest | \
    grep "browser_download_url.*tar.gz" | \
    cut -d '"' -f 4 | head -1)

if [ -n "$LATEST_URL" ]; then
    echo "  → Downloading Proton-GE..."
    curl -L "$LATEST_URL" -o /tmp/proton-ge.tar.gz
    
    echo "  → Extracting to $COMPAT_DIR..."
    tar -xzf /tmp/proton-ge.tar.gz -C "$COMPAT_DIR"
    rm /tmp/proton-ge.tar.gz
    
    echo "✅ Proton-GE installed successfully!"
    echo "ℹ️  Restart Steam and select Proton-GE in compatibility settings"
else
    echo "❌ Could not fetch Proton-GE release"
    exit 1
fi
INNEREOF
