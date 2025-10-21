#!/usr/bin/env bash
set -euo pipefail

# OnlyOffice installer for Omarchy via Flatpak
# - Installs OnlyOffice from Flathub
# - Creates a desktop entry with a custom icon
# - Idempotent: skips Flatpak install if present, safely re-writes .desktop

APP_NAME="OnlyOffice"
FLATPAK_ID="org.onlyoffice.desktopeditors"
ICON_URL="https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/onlyoffice.png"
ICON_DIR="$HOME/.local/share/applications/icons"
ICON_PATH="$ICON_DIR/onlyoffice.png"
DESKTOP_FILE="$HOME/.local/share/applications/$APP_NAME.desktop"
EXEC_COMMAND="flatpak run $FLATPAK_ID"

# Preconditions
if ! command -v flatpak >/dev/null 2>&1; then
  echo "Error: flatpak is not installed. Please run: bash flatpack.sh"
  exit 1
fi

# Ensure Flathub remote exists (user scope)
if ! flatpak remote-list --columns=name | grep -Fxq flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install ONLYOFFICE from Flathub (idempotent)
if ! flatpak info "$FLATPAK_ID" >/dev/null 2>&1; then
  echo "📦 Installing $APP_NAME from Flathub..."
  flatpak install -y flathub "$FLATPAK_ID"
else
  echo "$APP_NAME is already installed via Flatpak."
fi

# Ensure icon directory and download icon
mkdir -p "$ICON_DIR"
echo "🖼️ Downloading icon..."
curl -fL --retry 3 --retry-delay 2 -o "$ICON_PATH" "$ICON_URL"

# Create application .desktop file
echo "🖇️ Creating desktop entry..."
cat >"$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=$APP_NAME
Comment=$APP_NAME
Exec=$EXEC_COMMAND
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupNotify=true
EOF

chmod +x "$DESKTOP_FILE"

echo "✅ $APP_NAME setup complete! You can launch it from the app launcher, or with:"
echo "   $EXEC_COMMAND"
