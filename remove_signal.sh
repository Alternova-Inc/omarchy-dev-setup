#!/usr/bin/env bash
set -euo pipefail

# Remove Signal (repo/AUR), idempotent.
# Packages covered: signal-desktop, signal-desktop-beta

sudo -v  # Cache sudo password

# Find installed Signal packages
mapfile -t PKGS < <(pacman -Qq | grep -E '^signal-desktop(-beta)?$' || true)

if (( ${#PKGS[@]} > 0 )); then
  echo "Removing Signal packages: ${PKGS[*]}"
  sudo pacman -Rns --noconfirm "${PKGS[@]}"
  if command -v omarchy-show-done >/dev/null 2>&1; then
    omarchy-show-done
  fi
else
  echo "Signal already removed (no matching packages installed)."
fi
