#!/bin/bash
set -e

# MythOS Developer Pillar — Shell Environment

echo "🐚 Setting up developer shell environment..."

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
    delta

# Install Starship prompt
if ! command -v starship &> /dev/null; then
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Set up Starship config
mkdir -p ~/.config
cat > ~/.config/starship.toml << 'EOF'
# MythOS Starship Configuration

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

# Initialize Starship in bash
if ! grep -q "starship init bash" ~/.bashrc 2>/dev/null; then
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

# Set up zoxide
if ! grep -q "zoxide init bash" ~/.bashrc 2>/dev/null; then
    echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
fi

echo "✅ Shell environment configured!"
echo "💡 Restart your terminal or run: source ~/.bashrc"
