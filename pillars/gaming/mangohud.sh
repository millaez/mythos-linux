#!/bin/bash
set -e

# F.O.R.G.E. Gaming Pillar — MangoHud Setup
# Part of: forge-arch

echo "📊 Installing MangoHud and GameMode..."

# Determine target user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
fi

# Install MangoHud + GameMode
sudo pacman -S --needed --noconfirm \
    mangohud \
    lib32-mangohud \
    gamemode \
    lib32-gamemode

# Create MangoHud config
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/MangoHud"

sudo -u "$TARGET_USER" tee "$TARGET_HOME/.config/MangoHud/MangoHud.conf" > /dev/null << 'EOF'
# F.O.R.G.E. MangoHud Configuration

# Toggle
toggle_hud=Shift_R+F12

# Position and style
position=top-left
no_display=false
font_size=24
background_alpha=0.4
round_corners=5

# Performance metrics
fps
frametime=0
frame_timing=1

# CPU info
cpu_stats
cpu_temp
cpu_power
cpu_mhz

# GPU info
gpu_stats
gpu_temp
gpu_power
gpu_mem_clock
gpu_core_clock

# Memory
ram
vram

# Show GameMode status
gamemode

# Battery (for laptops)
battery

# Frame time graph
frame_timing=1
frametime_period=500

# Logging (press F2 to start/stop)
output_folder=/tmp/mangohud
log_duration=60
EOF

# Set up GameMode configuration
sudo tee /etc/gamemode.ini > /dev/null << 'EOF'
[general]
renice=10
softrealtime=auto
inhibit_screensaver=1

[gpu]
apply_gpu_optimisations=accept-responsibility
gpu_device=0
amd_performance_level=high

[cpu]
park_cores=no
pin_cores=no

[custom]
; Add custom scripts here if needed
; start=
; end=
EOF

# Enable GameMode daemon
sudo systemctl enable --now gamemoded || true

# Add user to gamemode group if it exists
if getent group gamemode > /dev/null; then
    sudo usermod -aG gamemode "$TARGET_USER" 2>/dev/null || true
fi

echo "✅ MangoHud and GameMode configured!"
echo ""
echo "💡 Steam launch options:"
echo "   mangohud %command%"
echo "   gamemoderun %command%"
echo "   mangohud gamemoderun %command%  (both)"
echo ""
echo "💡 Toggle HUD in-game: Shift_R + F12"
