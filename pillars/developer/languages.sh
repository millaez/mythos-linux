#!/bin/bash
set -e

# F.O.R.G.E. Developer Pillar — Programming Languages
# Part of: forge-arch

echo "💻 Installing programming language toolchains..."

# Determine target user
if [ -n "$SUDO_USER" ]; then
    TARGET_USER="$SUDO_USER"
    TARGET_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    TARGET_USER="$USER"
    TARGET_HOME="$HOME"
fi

# Python
echo "🐍 Installing Python stack..."
sudo pacman -S --needed --noconfirm \
    python \
    python-pip \
    python-pipx \
    python-virtualenv \
    ipython

# Rust (install as target user, not root)
echo "🦀 Installing Rust..."
if ! sudo -u "$TARGET_USER" bash -c 'command -v rustc' &> /dev/null; then
    sudo -u "$TARGET_USER" bash << 'EOF'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
EOF
    
    # Add to bashrc if not already there
    if ! grep -q "cargo/env" "$TARGET_HOME/.bashrc" 2>/dev/null; then
        sudo -u "$TARGET_USER" tee -a "$TARGET_HOME/.bashrc" > /dev/null << 'EOF'

# Rust
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
EOF
    fi
else
    echo "   Rust already installed, updating..."
    sudo -u "$TARGET_USER" bash -c 'source "$HOME/.cargo/env" && rustup update' || true
fi

# Node.js via nvm (more flexible than system nodejs)
echo "📦 Installing Node.js via nvm..."
if [ ! -d "$TARGET_HOME/.nvm" ]; then
    sudo -u "$TARGET_USER" bash << 'EOF'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
EOF
    
    # Install latest LTS
    sudo -u "$TARGET_USER" bash << 'EOF'
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'
EOF
else
    echo "   nvm already installed"
fi

# Go
echo "🐹 Installing Go..."
sudo pacman -S --needed --noconfirm go

# Add Go paths to bashrc
if ! grep -q "GOPATH" "$TARGET_HOME/.bashrc" 2>/dev/null; then
    sudo -u "$TARGET_USER" tee -a "$TARGET_HOME/.bashrc" > /dev/null << 'EOF'

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
EOF
fi

# Build essentials
echo "🔧 Installing build tools..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    cmake \
    ninja \
    meson \
    clang \
    llvm

# Database clients
echo "🗄️  Installing database tools..."
sudo pacman -S --needed --noconfirm \
    postgresql \
    sqlite

# Install Redis alternative (Valkey) or Redis from AUR
if pacman -Ss '^valkey$' &>/dev/null; then
    sudo pacman -S --needed --noconfirm valkey
else
    sudo pacman -S --needed --noconfirm redis 2>/dev/null || \
    sudo -u "$TARGET_USER" yay -S --needed --noconfirm redis
fi

echo ""
echo "✅ Programming languages installed!"
echo ""
echo "💡 Activate Rust: source ~/.cargo/env"
echo "💡 Activate Node: nvm use --lts"
echo "💡 Restart your shell or run: source ~/.bashrc"
