#!/usr/bin/env bash
set -euo pipefail

# Remove LibreOffice (repo/AUR), idempotent.
# Covers: libreoffice, libreoffice-fresh, libreoffice-still,
#         language/help/sdk/extensions like libreoffice-fresh-en-US, libreoffice-still-sdk, libreoffice-extension-*

sudo -v  # Cache sudo password

# Find installed LibreOffice packages
mapfile -t PKGS < <(pacman -Qq | grep -E '^libreoffice($|-.+)' || true)

if (( ${#PKGS[@]} > 0 )); then
  echo "Removing LibreOffice packages: ${PKGS[*]}"
  sudo pacman -Rns --noconfirm "${PKGS[@]}"
  if command -v omarchy-show-done >/dev/null 2>&1; then
    omarchy-show-done
  fi
else
  echo "LibreOffice already removed (no matching packages installed)."
fi
