#!/bin/bash
set -e

# F.O.R.G.E. Developer Pillar — Neovim Setup
# Part of: forge-arch

echo "📝 Setting up Neovim with LSP support..."

# Install Neovim and dependencies
sudo pacman -S --needed --noconfirm \
    neovim \
    git \
    python-pip \
    ripgrep \
    fd \
    unzip

# Determine target user (handle both sudo and direct root execution)
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
fi

# Install LazyVim as the target user
echo "📦 Installing LazyVim..."

sudo -u "$TARGET_USER" bash << EOF
set -e

# Backup existing Neovim config if it exists
if [ -d "$TARGET_HOME/.config/nvim" ]; then
    mv "$TARGET_HOME/.config/nvim" "$TARGET_HOME/.config/nvim.backup.\$(date +%s)"
    echo "⚠️  Backed up existing Neovim config"
fi

# Clone LazyVim starter
git clone https://github.com/LazyVim/starter "$TARGET_HOME/.config/nvim"

# Remove .git directory to make it your own
rm -rf "$TARGET_HOME/.config/nvim/.git"
EOF

# Install language servers via pacman where possible (more reliable)
echo "📦 Installing language servers via pacman..."
sudo pacman -S --needed --noconfirm \
    lua-language-server \
    rust-analyzer \
    gopls \
    pyright \
    bash-language-server \
    typescript-language-server \
    yaml-language-server \
    vscode-css-languageserver \
    vscode-html-languageserver \
    vscode-json-languageserver

# Install Python tools in user space (no sudo needed)
echo "📦 Installing Python language tools..."
sudo -u "$TARGET_USER" pip install --user --break-system-packages \
    python-lsp-server \
    pylint \
    black \
    isort 2>/dev/null || \
sudo -u "$TARGET_USER" pip install --user \
    python-lsp-server \
    pylint \
    black \
    isort

# Create custom Neovim config for F.O.R.G.E.
sudo -u "$TARGET_USER" mkdir -p "$TARGET_HOME/.config/nvim/lua/config"

sudo -u "$TARGET_USER" tee "$TARGET_HOME/.config/nvim/lua/config/options.lua" > /dev/null << 'EOF'
-- F.O.R.G.E. Neovim Options

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tabs and indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Appearance
vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Behavior
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true
EOF

echo "✅ Neovim configured with LazyVim!"
echo "💡 Run 'nvim' to complete plugin installation"
echo "💡 Press 'Space' to see available commands"
