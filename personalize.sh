#!/bin/bash
# MythOS Personalization Wizard
# Tailors MythOS specifically for ATLAS based on your needs

set -e

echo "🏛️ MythOS Personalization Wizard"
echo "=================================="
echo ""
echo "Let's make MythOS perfect for YOU!"
echo ""

# Detect current system
echo "Current system detected:"
echo "  Hostname: $(hostname)"
echo "  CPU: $(lscpu | grep "Model name" | cut -d: -f2 | xargs)"
echo "  RAM: $(free -h | awk '/^Mem:/ {print $2}')"
echo "  GPU: $(lspci | grep -i "vga\|3d" | head -1 | cut -d: -f3 | xargs)"
echo ""

# Detect GPU vendor
GPU_VENDOR="unknown"
if lspci | grep -i "nvidia" &>/dev/null; then
    GPU_VENDOR="nvidia"
elif lspci | grep -i "amd\|radeon" &>/dev/null; then
    GPU_VENDOR="amd"
elif lspci | grep -i "intel.*graphics" &>/dev/null; then
    GPU_VENDOR="intel"
fi
echo "  Detected GPU: $GPU_VENDOR"
echo ""

# Questions
read -p "What's your primary use? (1=Gaming, 2=Development, 3=Both equally): " PRIMARY_USE
read -p "What gaming types? (1=FPS, 2=RPG/Strategy, 3=Emulation, 4=All): " GAMING_TYPE
read -p "Development focus? (1=Web, 2=Systems, 3=AI/ML, 4=General): " DEV_FOCUS
read -p "Desktop preference? (1=Keep Plasma, 2=Try Hyprland, 3=Both): " DE_CHOICE
read -p "Priority? (1=Performance, 2=Beauty, 3=Balanced): " PRIORITY
read -p "Install mythology theme? (1=Greek, 2=Norse, 3=Egyptian, 4=All): " THEME_CHOICE

echo ""
echo "Generating personalized configuration..."
echo ""

# Create personalized profile
cat > ~/mythos-personalized.yaml << EOF
# MythOS Personalized Configuration for ATLAS
# Generated: $(date)

metadata:
  hostname: $(hostname)
  gpu: $GPU_VENDOR
  primary_use: $PRIMARY_USE
  gaming_type: $GAMING_TYPE
  dev_focus: $DEV_FOCUS
  de_choice: $DE_CHOICE
  priority: $PRIORITY

# Package selections based on your answers
packages:
  # Core gaming (everyone gets this)
  gaming_core:
    - steam
    - gamemode
    - mangohud
    - lib32-gcc-libs
    
  # FPS/Competitive gaming additions
  gaming_fps:
$([ "$GAMING_TYPE" = "1" ] || [ "$GAMING_TYPE" = "4" ] && cat << 'INNER'
    - gamescope  # Better frame pacing
    - corectrl   # GPU overclocking
INNER
)
  
  # Emulation additions
  gaming_emulation:
$([ "$GAMING_TYPE" = "3" ] || [ "$GAMING_TYPE" = "4" ] && cat << 'INNER'
    - retroarch
    - dolphin-emu
    - pcsx2
INNER
)
  
  # Developer tools
  dev_core:
    - git
    - docker
    - docker-compose
    - python
    - base-devel
    
  # Web development
  dev_web:
$([ "$DEV_FOCUS" = "1" ] || [ "$DEV_FOCUS" = "4" ] && cat << 'INNER'
    - nodejs
    - npm
    - nginx
INNER
)
  
  # Systems programming
  dev_systems:
$([ "$DEV_FOCUS" = "2" ] || [ "$DEV_FOCUS" = "4" ] && cat << 'INNER'
    - rust
    - go
    - clang
    - llvm
INNER
)
  
  # AI/ML
  dev_ai:
$([ "$DEV_FOCUS" = "3" ] || [ "$DEV_FOCUS" = "4" ] && cat << 'INNER'
    - python-pytorch
    - python-tensorflow
    - cuda # if nvidia
INNER
)
  
  # Desktop environment
  de_hyprland:
$([ "$DE_CHOICE" = "2" ] || [ "$DE_CHOICE" = "3" ] && cat << 'INNER'
    - hyprland
    - waybar
    - wofi
    - kitty
    - dunst
INNER
)
  
  # Performance optimizations
  performance:
$([ "$PRIORITY" = "1" ] || [ "$PRIORITY" = "3" ] && cat << 'INNER'
    - linux-zen       # Low-latency kernel
    - irqbalance      # Better IRQ handling
    - gamemode        # CPU governor switching
INNER
)
  
  # Beauty enhancements
  beauty:
$([ "$PRIORITY" = "2" ] || [ "$PRIORITY" = "3" ] && cat << 'INNER'
    - ttf-jetbrains-mono-nerd
    - ttf-fira-code
    - papirus-icon-theme
    - catppuccin-gtk-theme-mocha
INNER
)

# GPU-specific optimizations
gpu_$GPU_VENDOR:
$(if [ "$GPU_VENDOR" = "nvidia" ]; then cat << 'INNER'
  - nvidia-dkms
  - nvidia-settings
  - lib32-nvidia-utils
INNER
elif [ "$GPU_VENDOR" = "amd" ]; then cat << 'INNER'
  - mesa
  - vulkan-radeon
  - lib32-vulkan-radeon
INNER
fi
)

# System tweaks
tweaks:
  - disable_mitigations: $([ "$PRIORITY" = "1" ] && echo "true" || echo "false")
  - cpu_governor: $([ "$PRIORITY" = "1" ] && echo "performance" || echo "schedutil")
  - enable_zram: true
  - vm_swappiness: $([ "$PRIMARY_USE" = "1" ] && echo "10" || echo "60")
EOF

echo "✅ Configuration saved to: ~/mythos-personalized.yaml"
echo ""
cat ~/mythos-personalized.yaml
echo ""
echo "=================================="
echo ""
echo "📝 Recommended Actions:"
echo ""

# Recommendations based on answers
if [ "$DE_CHOICE" = "2" ] || [ "$DE_CHOICE" = "3" ]; then
    echo "  1. Install Hyprland:"
    echo "     cd ~/mythos-linux && sudo bash scripts/install-hyprland.sh"
    echo ""
fi

if [ "$GAMING_TYPE" = "1" ] || [ "$GAMING_TYPE" = "4" ]; then
    echo "  2. Install competitive gaming tools:"
    echo "     cd ~/mythos-linux && sudo bash scripts/gaming-competitive.sh"
    echo ""
fi

if [ "$GPU_VENDOR" = "nvidia" ]; then
    echo "  3. Optimize NVIDIA settings:"
    echo "     cd ~/mythos-linux && sudo bash scripts/nvidia-optimize.sh"
    echo ""
fi

if [ "$PRIORITY" = "1" ]; then
    echo "  4. Apply performance tweaks:"
    echo "     cd ~/mythos-linux && sudo bash scripts/performance-max.sh"
    echo ""
fi

echo "  5. Install personalized profile:"
echo "     cd ~/mythos-linux"
echo "     sudo python3 provisioner.py --profile ~/mythos-personalized.yaml"
echo ""
echo "=================================="
echo ""
echo "🏛️ Your personalized MythOS awaits!"
