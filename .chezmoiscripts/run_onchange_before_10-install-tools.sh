#!/usr/bin/env bash
set -euo pipefail

# Ensure ~/.local/bin exists and is on the PATH for the script's subshell
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

echo "==> Checking development runtimes and tools..."

# 1. uv (Astral)
if ! command -v uv &>/dev/null; then
  echo "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh
else
  echo "uv already installed."
fi

# 2. fnm (Fast Node Manager)
if ! command -v fnm &>/dev/null; then
  echo "Installing fnm..."
  curl -fsSL https://fnm.vercel.app/install | bash -s -- --skip-shell
else
  echo "fnm already installed."
fi

# 3. Vim with clipboard support (+clipboard)
if ! vim --version | grep -qw '\+clipboard'; then
  echo "Configuring vim-gtk3 for clipboard support..."
  sudo apt-get update -qq && sudo apt-get install -y -qq vim-gtk3
  sudo update-alternatives --set vim /usr/bin/vim.gtk3
else
  echo "vim with clipboard support already active."
fi

# 4. Claude Code (native/standalone curl installer)
if ! command -v claude &>/dev/null; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed."
fi

# 5. Antigravity (standalone curl installer)
if ! command -v agy &>/dev/null && ! command -v antigravity &>/dev/null; then
  echo "Installing Antigravity..."
  curl -fsSL https://antigravity.google/cli/install.sh | bash
else
  echo "Antigravity (agy) already installed."
fi

# 6. Azure CLI
if ! command -v az &>/dev/null; then
  echo "Installing Azure CLI..."
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
  echo "Azure CLI already installed."
fi

# 7. Markdown TUI (glow)
if ! command -v glow &>/dev/null; then
  echo "Installing glow..."
  # Charmbracelet official apt setup
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
  sudo apt-get update -qq && sudo apt-get install -y -qq glow
else
  echo "glow already installed."
fi

# Ensure sync root exists
mkdir -p "$HOME/Sync"

# 8. Syncthing (official APT repo)
if ! command -v syncthing &>/dev/null; then
  echo "Installing Syncthing..."
  sudo mkdir -p /etc/apt/keyrings
  sudo curl -fsSL -o /etc/apt/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
  echo "deb [signed-by=/etc/apt/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list > /dev/null
  sudo apt-get update -qq && sudo apt-get install -y -qq syncthing
else
  echo "Syncthing already installed."
fi

# 9. Typst (pre-compiled binary to ~/.local/bin)
if ! command -v typst &>/dev/null; then
  echo "Installing Typst..."
  TYPST_VERSION=$(curl -fsSL https://api.github.com/repos/typst/typst/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  curl -fsSL "https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/typst-x86_64-unknown-linux-musl.tar.xz" | tar -xJ -C /tmp
  mkdir -p "$HOME/.local/bin"
  mv "/tmp/typst-x86_64-unknown-linux-musl/typst" "$HOME/.local/bin/typst"
  rm -rf "/tmp/typst-x86_64-unknown-linux-musl"
else
  echo "Typst already installed."
fi

# 10. Quarto CLI (.deb release)
if ! command -v quarto &>/dev/null; then
  echo "Installing Quarto..."
  QUARTO_VERSION=$(curl -fsSL https://api.github.com/repos/quarto-dev/quarto-cli/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
  curl -fsSL -o /tmp/quarto.deb "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb"
  sudo apt-get install -y -qq /tmp/quarto.deb
  rm -f /tmp/quarto.deb
else
  echo "Quarto already installed."
fi

# 11. Evince & typography for WGU Typst rendering (live PDF viewing via WSLg)
if ! command -v evince &>/dev/null; then
  echo "Installing Evince and fonts-linuxlibertine..."
  sudo apt-get update -qq && sudo apt-get install -y -qq evince fonts-linuxlibertine
else
  echo "Evince already installed."
fi

echo "==> All tools provisioned."
