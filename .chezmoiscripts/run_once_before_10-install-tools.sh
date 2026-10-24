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

# 3. Claude Code (native/standalone curl installer)
if ! command -v claude &>/dev/null; then
  echo "Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
else
  echo "Claude Code already installed."
fi

# 4. Antigravity (standalone curl installer)
if ! command -v antigravity &>/dev/null; then
  echo "Installing Antigravity..."
  curl -fsSL https://antigravity.google/cli/install.sh | bash
else
  echo "Antigravity already installed."
fi

# 5. Azure CLI
if ! command -v az &>/dev/null; then
  echo "Installing Azure CLI..."
  curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
else
  echo "Azure CLI already installed."
fi

# 6. Markdown TUI (glow)
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

echo "==> All tools provisioned."
