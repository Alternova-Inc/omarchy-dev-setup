#!/usr/bin/env bash
set -euo pipefail

# Remove Typora (repo/AUR), idempotent.
# Packages covered: typora, typora-free, typora-nightly

sudo -v  # Cache sudo password

# Find installed Typora packages
mapfile -t PKGS < <(pacman -Qq | grep -E '^typora(-free|-nightly)?$' || true)

if (( ${#PKGS[@]} > 0 )); then
  echo "Removing Typora packages: ${PKGS[*]}"
  sudo pacman -Rns --noconfirm "${PKGS[@]}"
  if command -v omarchy-show-done >/dev/null 2>&1; then
    omarchy-show-done
  fi
else
  echo "Typora already removed (no matching packages installed)."
fi
