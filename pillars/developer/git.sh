#!/bin/bash
set -e

# F.O.R.G.E. Developer Pillar — Git Configuration
# Part of: forge-arch

echo "🔧 Configuring Git with modern defaults..."

# Determine target user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
fi

# Install Git and related tools
sudo pacman -S --needed --noconfirm \
    git \
    git-delta \
    github-cli \
    lazygit

# Configure Git as the target user
sudo -u "$TARGET_USER" bash << 'GITCONFIG'
# Check if Git user is already configured
if git config --global user.name &> /dev/null; then
    echo "⚠️  Git user already configured, preserving existing settings"
else
    echo ""
    echo "📝 Git user not configured."
    echo "   Configure later with:"
    echo "   git config --global user.name 'Your Name'"
    echo "   git config --global user.email 'your@email.com'"
fi

# Set up Git aliases
git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Modern Git defaults
git config --global init.defaultBranch main
git config --global pull.rebase true
git config --global fetch.prune true
git config --global diff.colorMoved zebra

# Set up delta as diff tool
git config --global core.pager delta
git config --global interactive.diffFilter "delta --color-only"
git config --global delta.navigate true
git config --global delta.light false
git config --global delta.side-by-side true
git config --global merge.conflictstyle diff3
git config --global diff.colorMoved default

# Delta theme (Catppuccin)
git config --global delta.syntax-theme "Catppuccin Mocha"

# Set up credential helper
git config --global credential.helper store
GITCONFIG

# Create global gitignore
sudo -u "$TARGET_USER" tee "$TARGET_HOME/.gitignore_global" > /dev/null << 'EOF'
# F.O.R.G.E. Global Gitignore

# Editor directories and files
.vscode/
.idea/
*.swp
*.swo
*~
.DS_Store

# OS files
Thumbs.db
.Trash-*

# Build outputs
*.o
*.pyc
__pycache__/
node_modules/
target/
dist/
build/

# Environment files
.env
.env.local
*.log
EOF

sudo -u "$TARGET_USER" git config --global core.excludesfile "$TARGET_HOME/.gitignore_global"

echo ""
echo "✅ Git configured with modern defaults!"
echo ""
echo "💡 Authenticate with GitHub: gh auth login"
echo "💡 Terminal UI for Git: lazygit"
echo ""
echo "💡 If not configured, set your identity:"
echo "   git config --global user.name 'Your Name'"
echo "   git config --global user.email 'your@email.com'"
