#!/bin/bash
set -e

# MythOS Developer Pillar — Neovim Setup

echo "📝 Setting up Neovim with LSP support..."

# Install Neovim and dependencies
sudo pacman -S --needed --noconfirm \
    neovim \
    git \
    nodejs \
    npm \
    python-pip \
    ripgrep \
    fd \
    unzip

# Install LazyVim (modern Neovim distribution)
echo "📦 Installing LazyVim..."

# Backup existing Neovim config if it exists
if [ -d ~/.config/nvim ]; then
    mv ~/.config/nvim ~/.config/nvim.backup.$(date +%s)
    echo "⚠️  Backed up existing Neovim config"
fi

# Clone LazyVim starter
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove .git directory to make it your own
rm -rf ~/.config/nvim/.git

# Install common LSP servers
echo "📦 Installing language servers..."

# Install via npm
npm install -g \
    typescript-language-server \
    vscode-langservers-extracted \
    yaml-language-server \
    bash-language-server

# Install via pip
pip install --user \
    python-lsp-server \
    pylint \
    black \
    isort

# Install via pacman
sudo pacman -S --needed --noconfirm \
    rust-analyzer \
    gopls

# Create custom Neovim config for MythOS
mkdir -p ~/.config/nvim/lua/config

cat > ~/.config/nvim/lua/config/options.lua << 'EOF'
-- MythOS Neovim Options

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

# Create autocmds file
cat > ~/.config/nvim/lua/config/autocmds.lua << 'EOF'
-- MythOS Neovim Autocmds

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  command = [[%s/\s\+$//e]],
})
EOF

echo "✅ Neovim configured with LazyVim!"
echo "💡 Run 'nvim' to complete plugin installation"
echo "💡 Press 'Space' to see available commands"
echo "💡 Use ':checkhealth' to verify LSP setup"
