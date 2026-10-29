#!/usr/bin/env bash
set -euo pipefail

# Ensure ~/.local/bin exists and is on the PATH for the script's subshell
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# OS-Specific Setup: Debian/Ubuntu (WSL)
if command -v apt >/dev/null 2>&1; then
    # Fix Microsoft GPG Key missing on fresh Ubuntu installs
    if [ ! -f /etc/apt/trusted.gpg.d/microsoft.gpg ]; then
        echo "Installing Microsoft GPG key globally..."
        curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg
    fi
fi

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

# 2.5 Initialize fnm in this subshell and install the latest LTS version of Node.js
eval "$(fnm env --fnm-dir "$HOME/.local/share/fnm")"
fnm install --lts
fnm default lts-latest 

# 3. Neovim (modern release) and clipboard support
if ! command -v nvim &> /dev/null; then
  echo "Installing Neovim from official GitHub release..."
  wget -qO /tmp/nvim.tar.gz https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  mkdir -p $HOME/.local
  tar -C $HOME/.local --strip-components=1 -xzf /tmp/nvim.tar.gz
  rm /tmp/nvim.tar.gz
  sudo apt-get install -y -qq xclip
else
  echo "Neovim is already installed."
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

# 12. Obsidian (native GUI via WSLg)
if ! command -v obsidian &>/dev/null; then
  echo "Installing Obsidian via .deb..."
  OBSIDIAN_DEB="/tmp/obsidian.deb"
  OBSIDIAN_URL=$(curl -s https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest \
    | grep "browser_download_url.*_amd64.deb" \
    | cut -d '"' -f 4)

  if [ -n "$OBSIDIAN_URL" ]; then
    curl -sL "$OBSIDIAN_URL" -o "$OBSIDIAN_DEB"
    sudo apt-get update -qq && sudo apt-get install -y -qq "$OBSIDIAN_DEB"
    rm -f "$OBSIDIAN_DEB"
  else
    echo "Warning: Could not fetch Obsidian download URL."
  fi
else
  echo "Obsidian already installed."
fi

# 13. Database Command Line Clients (PostgreSQL & SQL Server)
echo "Checking database clients..."
sudo apt-get install -y -qq postgresql-client

if ! command -v sqlcmd &> /dev/null; then
    echo "Installing Microsoft SQL Server tools..."
    # 1. Store the key in the modern keyrings directory
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --yes --dearmor -o /etc/apt/keyrings/microsoft-prod.gpg
    
    # 2. Write the source list manually, forcing the signed-by tag
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/microsoft-prod.gpg] https://packages.microsoft.com/ubuntu/24.04/prod noble main" | sudo tee /etc/apt/sources.list.d/mssql-release.list > /dev/null
    
    # 3. Update and install silently
    sudo apt-get update
    sudo ACCEPT_EULA=Y apt-get install -y msodbcsql18 mssql-tools18
fi

echo "==> All tools provisioned."

