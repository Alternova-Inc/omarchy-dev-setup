#!/usr/bin/env bash
CURRENT_DIRECTORY=$(pwd)
sudo -v  # Cache sudo password

echo "🚀 Installing Alternova Development Environment..."

echo "📦 Updating Packages..."
sudo pacman -Syu --noconfirm

echo "🔒 Installing security packages..."
# Note: Security packages installation command not specified

echo "📥 Downloading Drata Agent AppImage..."
bash drata-agent.sh

echo "⚓ Installing fleet..."
bash fleet.sh

echo "🗑️ Removing Web Apps..."
bash remove_apps.sh

echo "Installing Microsoft Teams web app..."
bash teams.sh

echo "🛠️ Installing Yay..."
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd "$CURRENT_DIRECTORY"

echo "💻 Installing VSCode..."
yay -S --noconfirm visual-studio-code-bin

echo "🎨 Installing Alternity Theme..."
omarchy-theme-install https://github.com/Alternova-Inc/omarchy-alternity-theme

echo "✅ Installation complete! 🎉"
