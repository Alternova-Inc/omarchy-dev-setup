#!/usr/bin/env bash
set -euo pipefail

# Omarchy-style Flatpak bootstrap (inline package array, not from a file)
# - Installs Flatpak via pacman (idempotent with --needed)
# - Adds Flathub remote if missing (user scope)
# - Does not rely on AUR or yay

sudo -v  # Cache sudo password

PACKAGES=(flatpak)

echo "📦 Installing Flatpak and prerequisites..."
sudo pacman -S --noconfirm --needed "${PACKAGES[@]}"

echo "🌐 Ensuring Flathub remote is configured..."
if ! flatpak remote-list --columns=name | grep -Fxq flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  echo "➕ Added Flathub remote."
else
  echo "✔ Flathub remote already present."
fi

echo "✅ Flatpak setup complete! 🎉"
