#!/usr/bin/env bash
set -euo pipefail

# Ensure systemd user instance is reachable (WSL2 with systemd enabled)
if command -v systemctl >/dev/null 2>&1 && systemctl --user is-system-running >/dev/null 2>&1 || [ "$?" -le 1 ]; then
  # Enable and start syncthing user service if installed
  if command -v syncthing >/dev/null 2>&1; then
    if ! systemctl --user is-enabled syncthing >/dev/null 2>&1; then
      echo "==> Enabling Syncthing user service..."
      systemctl --user enable --now syncthing
    else
      echo "Syncthing user service is already enabled."
    fi
  fi
fi
