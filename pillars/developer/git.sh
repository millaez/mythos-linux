#!/bin/bash
set -e

# MythOS Developer Pillar — Git Configuration

echo "🔧 Configuring Git with modern defaults..."

# Install Git and related tools
sudo pacman -S --needed --noconfirm \
    git \
    git-delta \
    github-cli \
    lazygit

# Check if Git is already configured
if git config --global user.name &> /dev/null; then
    echo "⚠️  Git already configured. Skipping user setup."
    SKIP_USER_CONFIG=true
else
    SKIP_USER_CONFIG=false
fi

# Interactive Git user configuration
if [ "$SKIP_USER_CONFIG" = false ]; then
    echo ""
    echo "📝 Git User Configuration"
    echo "────────────────────────"
    read -p "Enter your name: " GIT_NAME
    read -p "Enter your email: " GIT_EMAIL
    
    git config --global user.name "$GIT_NAME"
    git config --global user.email "$GIT_EMAIL"
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
git config --global delta.syntax-theme "Catppuccin-mocha"

# Set up credential helper
git config --global credential.helper store

# Create global gitignore
cat > ~/.gitignore_global << 'EOF'
# MythOS Global Gitignore

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

git config --global core.excludesfile ~/.gitignore_global

echo "✅ Git configured with modern defaults!"
echo "💡 Use 'gh auth login' to authenticate with GitHub"
echo "💡 Use 'lazygit' for a terminal UI"
