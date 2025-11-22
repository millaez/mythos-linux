#!/bin/bash
set -e

# F.O.R.G.E. Developer Pillar — Shell Environment
# Part of: forge-arch

echo "🐚 Setting up developer shell environment..."

# Determine target user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
fi

# Install modern shell tools
sudo pacman -S --needed --noconfirm \
    fish \
    starship \
    zoxide \
    fzf \
    bat \
    eza \
    fd \
    ripgrep \
    git-delta

# Set up Starship config
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config"
sudo -u "$TARGET_USER" tee "$TARGET_HOME/.config/starship.toml" > /dev/null << 'EOF'
# F.O.R.G.E. Starship Configuration

format = """
[╭─](bold green)$username$hostname$directory$git_branch$git_status
[╰─](bold green)$character"""

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[username]
style_user = "bold cyan"
style_root = "bold red"
format = "[$user]($style) "
show_always = true

[hostname]
ssh_only = false
format = "[@$hostname](bold yellow) "

[directory]
truncation_length = 3
truncate_to_repo = true
format = "[$path]($style)[$read_only]($read_only_style) "
style = "bold blue"

[git_branch]
symbol = " "
format = "[$symbol$branch]($style) "
style = "bold purple"

[git_status]
format = '([\[$all_status$ahead_behind\]]($style) )'
style = "bold red"
EOF

# Add shell enhancements to bashrc
BASHRC_FILE="$TARGET_HOME/.bashrc"

# Starship
if ! grep -q "starship init bash" "$BASHRC_FILE" 2>/dev/null; then
    sudo -u "$TARGET_USER" tee -a "$BASHRC_FILE" > /dev/null << 'EOF'

# F.O.R.G.E. Shell Enhancements
eval "$(starship init bash)"
EOF
fi

# Zoxide
if ! grep -q "zoxide init bash" "$BASHRC_FILE" 2>/dev/null; then
    sudo -u "$TARGET_USER" tee -a "$BASHRC_FILE" > /dev/null << 'EOF'
eval "$(zoxide init bash)"
EOF
fi

# FZF
if ! grep -q "fzf --bash" "$BASHRC_FILE" 2>/dev/null; then
    sudo -u "$TARGET_USER" tee -a "$BASHRC_FILE" > /dev/null << 'EOF'
eval "$(fzf --bash)"
EOF
fi

# Modern CLI aliases
if ! grep -q "alias ls='eza" "$BASHRC_FILE" 2>/dev/null; then
    sudo -u "$TARGET_USER" tee -a "$BASHRC_FILE" > /dev/null << 'EOF'

# Modern CLI replacements
alias ls='eza --icons'
alias ll='eza -la --icons'
alias la='eza -a --icons'
alias lt='eza --tree --icons'
alias cat='bat --paging=never'
alias grep='rg'
alias find='fd'
EOF
fi

# Also configure fish if user wants to try it
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/fish"
sudo -u "$TARGET_USER" tee "$TARGET_HOME/.config/fish/config.fish" > /dev/null << 'EOF'
# F.O.R.G.E. Fish Configuration

if status is-interactive
    # Starship prompt
    starship init fish | source
    
    # Zoxide
    zoxide init fish | source
    
    # Aliases
    alias ls='eza --icons'
    alias ll='eza -la --icons'
    alias la='eza -a --icons'
    alias lt='eza --tree --icons'
    alias cat='bat --paging=never'
    alias grep='rg'
    alias find='fd'
end
EOF

echo "✅ Shell environment configured!"
echo "💡 Restart your terminal or run: source ~/.bashrc"
echo "💡 Try fish shell with: fish"
echo "💡 Set fish as default: chsh -s /usr/bin/fish"
