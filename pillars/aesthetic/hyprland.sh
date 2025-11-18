#!/bin/bash
set -e

# MythOS Aesthetic Pillar — Hyprland Setup

echo "🎨 Installing Hyprland and Wayland ecosystem..."

# Install Hyprland and core Wayland components
sudo pacman -S --needed --noconfirm \
    hyprland \
    xdg-desktop-portal-hyprland \
    qt5-wayland \
    qt6-wayland \
    polkit-kde-agent

# Install compositor utilities
sudo pacman -S --needed --noconfirm \
    waybar \
    wofi \
    dunst \
    swaybg \
    swaylock \
    swayidle \
    grim \
    slurp \
    wl-clipboard

# Install terminal and file manager
sudo pacman -S --needed --noconfirm \
    alacritty \
    thunar \
    thunar-archive-plugin \
    file-roller

# Install fonts
echo "🔤 Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono \
    ttf-jetbrains-mono-nerd \
    ttf-fira-code \
    ttf-font-awesome \
    noto-fonts \
    noto-fonts-emoji

# Create Hyprland config directory
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/wofi
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/dunst

# Basic Hyprland config
cat > ~/.config/hypr/hyprland.conf << 'EOF'
# MythOS Hyprland Configuration

# Monitor setup
monitor=,preferred,auto,1

# Startup
exec-once = waybar
exec-once = dunst
exec-once = /usr/lib/polkit-kde-authentication-agent-1

# Input configuration
input {
    kb_layout = us
    follow_mouse = 1
    touchpad {
        natural_scroll = yes
    }
    sensitivity = 0
}

# General appearance
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(cba6f7ee) rgba(89b4faee) 45deg
    col.inactive_border = rgba(585b70aa)
    layout = dwindle
}

# Decoration
decoration {
    rounding = 10
    blur {
        enabled = true
        size = 3
        passes = 1
    }
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Layouts
dwindle {
    pseudotile = yes
    preserve_split = yes
}

# Keybindings
$mainMod = SUPER

bind = $mainMod, Return, exec, alacritty
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, thunar
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, wofi --show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Switch workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5

# Move window to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5

# Screenshot
bind = , Print, exec, grim -g "$(slurp)" - | wl-copy
EOF

echo "✅ Hyprland installed and configured!"
echo "💡 Log out and select Hyprland from your display manager"
echo "💡 Or run: Hyprland"
