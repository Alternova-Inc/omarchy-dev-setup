#!/usr/bin/env bash
set -euo pipefail

# OnlyOffice installer for Omarchy using yay (AUR)
# - Installs the AUR package: onlyoffice
# - Idempotent: skips if already installed

sudo -v  # Cache sudo password

PKG="onlyoffice"

# Preconditions
if ! command -v yay >/dev/null 2>&1; then
  echo "Error: yay is not installed or not in PATH. Please install yay first."
  exit 1
fi

# Idempotency: skip if already installed
if pacman -Qi "$PKG" >/dev/null 2>&1; then
  echo "OnlyOffice ($PKG) already installed."
  echo "✅ Installation complete! 🎉"
  exit 0
fi

echo "📦 Installing OnlyOffice from AUR with yay: $PKG"
yay -S --noconfirm --needed "$PKG"

echo "✅ Installation complete! 🎉"
