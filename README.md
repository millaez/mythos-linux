# 🏛️ # 🜁 MythOS Linux

> **A curated Arch-based distribution for gaming, development, and aesthetic perfection.**

MythOS is a modular, reproducible Linux environment that combines:
- **🎮 Gaming Performance** — CachyOS kernel, Proton, MangoHud, GameMode
- **💻 Developer Workflow** — Hyprland, modern tooling, containerized dev environments
- **🎨 Aesthetic Polish** — Catppuccin themes, clean configs, thoughtful defaults

**Philosophy:** Don't reinvent Arch. Curate the best parts of the modern Linux ecosystem.

---

## ✨ Features

### 🎮 Gaming Pillar
- **Steam & Proton** — Gaming out-of-the-box with Steam Play enabled
- **Performance Tools** — MangoHud for monitoring, GameMode for optimization
- **Proton-GE** — Latest compatibility layer for Windows games
- **Lutris** — Universal game launcher for all platforms
- **GPU Optimized** — Pre-configured for NVIDIA, AMD, and Intel graphics

### 💻 Developer Pillar
- **Hyprland** — Modern Wayland compositor with tiling workflow
- **Distrobox/Podman** — Containerized development environments
- **Modern Shell** — Starship prompt, zoxide, fzf, bat, eza
- **Language Toolchains** — Python, Rust, Node.js, Go pre-installed
- **Neovim Ready** — Configured editor with LSP support

### 🎨 Aesthetic Pillar
- **Catppuccin Theme** — Mocha palette across all applications
- **Waybar** — Beautiful status bar with system monitoring
- **Wofi** — App launcher styled to match
- **JetBrains Mono** — Nerd Font for perfect icon rendering
- **Consistent Design** — Every tool follows the same aesthetic

---

## 🚀 Quick Start

### Prerequisites
- Fresh Arch Linux install (or existing Arch system)
- Internet connection
- `git` installed

### One-Line Install

```bash
git clone https://github.com/millaez/mythos-linux.git
cd mythos-linux
./provisioner.py --profile atlas
```

This will:
1. Bootstrap the base Arch system
2. Install gaming stack (Steam, MangoHud, Proton-GE)
3. Set up developer tools (Hyprland, Distrobox, languages)
4. Apply aesthetic configuration (themes, fonts, Waybar)

### Modular Installation

You can also install individual pillars:

```bash
# Just the base system
./provisioner.py --bootstrap

# Add gaming support
./provisioner.py --gaming

# Add developer tools
./provisioner.py --dev

# Add aesthetic configuration
./provisioner.py --aesthetic
```

---

## 📁 Repository Structure

```
mythos-linux/
├── bootstrap/          # Base Arch system setup
│   └── arch.sh
├── pillars/            # Modular feature sets
│   ├── gaming/         # Steam, MangoHud, Proton-GE
│   ├── developer/      # Shell, languages, containers
│   └── aesthetic/      # Hyprland, Waybar, themes
├── profiles/           # Pre-configured system profiles
│   └── atlas.yaml      # Full-featured workstation
├── traits/             # Reusable behavior sets
│   └── steamos.yaml    # SteamOS-like gaming defaults
├── core/               # Python orchestration
│   └── themes/         # Theme management system
└── provisioner.py      # Main installation script
```

---

## 🎯 Profiles

### ATLAS (Default)
Full-featured workstation with gaming, development, and aesthetic polish.

```bash
./provisioner.py --profile atlas
```

**Includes:**
- Gaming: Steam, Lutris, MangoHud, Proton-GE
- Development: Hyprland, Distrobox, Python/Rust/Node/Go
- Aesthetic: Catppuccin theme, Waybar, JetBrains Mono
- Applications: Firefox, Discord, OBS Studio

### Create Your Own Profile

```yaml
# profiles/myprofile.yaml
name: "MyProfile"
description: "Custom MythOS setup"

traits:
  - steamos

bootstrap: true

pillars:
  gaming:
    - steam
    - mangohud
  developer:
    - shell
    - distrobox
  aesthetic:
    - hyprland

theme:
  style: "catppuccin-mocha"
  font: "JetBrains Mono"
```

---

## 🔧 System Requirements

### Minimum
- **CPU:** x86_64 processor
- **RAM:** 4GB (8GB recommended)
- **Storage:** 30GB free space
- **GPU:** Any (NVIDIA/AMD/Intel)

### Recommended
- **CPU:** Modern multi-core processor
- **RAM:** 16GB+
- **Storage:** 100GB+ SSD
- **GPU:** Dedicated NVIDIA/AMD card

---

## 🛠️ Customization

### Gaming Tweaks

```bash
# Add custom Steam library location
mkdir -p ~/Games/SteamLibrary

# Configure MangoHud
nano ~/.config/MangoHud/MangoHud.conf

# Install additional compatibility tools
yay -S proton-ge-custom-bin
```

### Developer Environment

```bash
# Install additional languages
./pillars/developer/languages.sh

# Set up containerized environment
./pillars/developer/distrobox.sh

# Customize shell prompt
nano ~/.config/starship.toml
```

### Aesthetic Changes

```bash
# Switch to Nord theme
# (Theme manager coming soon)

# Customize Hyprland
nano ~/.config/hypr/hyprland.conf

# Adjust Waybar
nano ~/.config/waybar/config
```

---

## 🌟 Inspiration

MythOS draws inspiration from:
- **SteamOS** — Gaming-first approach
- **Bazzite** — Performance optimizations
- **NixOS** — Reproducibility philosophy
- **elementary OS** — Aesthetic consistency
- **Fedora** — Modern toolchain

---

## 📚 Documentation

--- (not yet)

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

---

## 📜 License

Public Domain

---

## 🙏 Acknowledgments

- **Arch Linux** community for the solid foundation
- **CachyOS** team for performance kernels
- **Catppuccin** for the beautiful theme
- **Hyprland** developers for the excellent compositor
- All the open-source projects that make MythOS possible

---

## 📬 Contact

- **GitHub:** [@millaez](https://github.com/millaez)
- **Repository:** [mythos-linux](https://github.com/millaez/mythos-linux)

---

**Built with ❤️ for gamers and developers who refuse to compromise.**
