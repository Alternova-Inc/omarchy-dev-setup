#!/usr/bin/env bash
CURRENT_DIRECTORY=$(pwd)
sudo -v  # Cache sudo password

echo "🚀 Installing Alternova Development Environment..."

echo "📦 Step 1/6: Updating Packages..."
sudo pacman -Syu --noconfirm

echo "🔒 Step 2/6: Installing security packages..."
# Note: Security packages installation command not specified

echo "📥 Step 3/6: Downloading Drata Agent AppImage..."
bash drata-agent.sh

echo "⚓ Step 4/6: Installing fleet..."
bash fleet.sh

echo "🛠️ Step 5/6: Installing Yay..."
sudo pacman -S --needed --noconfirm git base-devel
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si --noconfirm
cd "$CURRENT_DIRECTORY"

echo "💻 Step 6/6: Installing VSCode..."
yay -S --noconfirm visual-studio-code-bin

echo "🎨 Installing Alternity Theme..."
omarchy-theme-install https://github.com/Alternova-Inc/omarchy-alternity-theme

echo "✅ Installation complete! 🎉"