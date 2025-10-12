#!/usr/bin/env bash
CURRENT_DIRECTORY=$(pwd)
sudo -v  # Cache sudo password

echo "🚀 Installing Alternova Development Environment..."

echo "📦 Step 1/7: Updating Packages..."
sudo pacman -Syu --noconfirm

echo "🔒 Step 2/7: Installing security packages..."
# Note: Security packages installation command not specified

echo "📥 Step 3/7: Downloading Drata Agent AppImage..."
bash drata-agent.sh

echo "⚓ Step 4/7: Installing fleet..."
bash fleet.sh

echo "🗑️ Step 5/7: Removing Web Apps..."
bash remove_apps.sh

echo "🛠️ Step 6/7: Installing Yay..."
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd "$CURRENT_DIRECTORY"

echo "💻 Step 7/7: Installing VSCode..."
yay -S --noconfirm visual-studio-code-bin

echo "🎨 Installing Alternity Theme..."
omarchy-theme-install https://github.com/Alternova-Inc/omarchy-alternity-theme

echo "✅ Installation complete! 🎉"
