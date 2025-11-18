#!/bin/bash
set -e

# MythOS Gaming Pillar — GameMode Advanced Setup

echo "⚡ Configuring GameMode for maximum performance..."

# Install GameMode (if not already installed)
sudo pacman -S --needed --noconfirm \
    gamemode \
    lib32-gamemode

# Advanced GameMode configuration
sudo tee /etc/gamemode.ini > /dev/null << 'EOF'
[general]
; Renice game process for higher priority
renice=10

; DesktopEntry to trigger when starting/ending game
start_hook=/usr/bin/notify-send "GameMode started"
end_hook=/usr/bin/notify-send "GameMode ended"

[filter]
; Whitelist/blacklist for processes
whitelist=
blacklist=

[gpu]
; Apply GPU optimizations (NVIDIA/AMD)
apply_gpu_optimisations=accept-responsibility
gpu_device=0

; AMD specific
amd_performance_level=high

[cpu]
; CPU governor (should be 'performance' for gaming)
gov_on_start=performance
gov_on_stop=powersave

; CPU core parking/pinning
park_cores=no
pin_cores=no

[custom]
; Custom scripts
start=/usr/local/bin/gamemode-start.sh
end=/usr/local/bin/gamemode-end.sh
EOF

# Create custom start script
sudo tee /usr/local/bin/gamemode-start.sh > /dev/null << 'EOF'
#!/bin/bash
# Disable compositor effects for performance
if pgrep -x "Hyprland" > /dev/null; then
    hyprctl keyword decoration:blur:enabled false
    hyprctl keyword decoration:drop_shadow false
fi

# Set CPU governor to performance
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
EOF

# Create custom end script
sudo tee /usr/local/bin/gamemode-end.sh > /dev/null << 'EOF'
#!/bin/bash
# Re-enable compositor effects
if pgrep -x "Hyprland" > /dev/null; then
    hyprctl keyword decoration:blur:enabled true
    hyprctl keyword decoration:drop_shadow true
fi

# Restore CPU governor
echo powersave | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
EOF

# Make scripts executable
sudo chmod +x /usr/local/bin/gamemode-start.sh
sudo chmod +x /usr/local/bin/gamemode-end.sh

# Enable and start GameMode daemon
sudo systemctl enable --now gamemoded

# Add user to gamemode group
sudo usermod -aG gamemode $USER

echo "✅ GameMode configured with performance optimizations!"
echo "💡 Use 'gamemoderun <game>' or enable in Steam launch options"
echo "💡 Log out and back in for group changes to take effect"
