#!/usr/bin/env bash
set -euo pipefail

# Clockify Web App installer for Omarchy
# 1) Download icon to ~/.local/share/applications/icons/clockify.png
# 2) Install Clockify with omarchy-webapp-install
# 3) Add Hypr binding to ~/.config/hypr/bindings.conf
# 4) Print completion message

APP_NAME="Clockify"
APP_URL="https://clockify.me"
ICON_DIR="$HOME/.local/share/applications/icons"
ICON_PATH="$ICON_DIR/clockify.png"
BINDINGS_FILE="$HOME/.config/hypr/bindings.conf"
BIND_LINE='bindd = SUPER SHIFT, C, Clockify, exec, omarchy-launch-or-focus-webapp Clockify "https://clockify.me"'

# Ensure icon directory exists
mkdir -p "$ICON_DIR"

# 1) Download the Clockify icon (using provided logo URL), saved as clockify.png
curl -fL --retry 3 --retry-delay 2 \
  -o "$ICON_PATH" \
  "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/leantime.png"

# 2) Install Clockify as a web app using the specified command.
# The installer expects the icon filename (not a full path), so run from the icon directory.
(
  cd "$ICON_DIR"
  omarchy-webapp-install "$APP_NAME" "$APP_URL" "clockify.png"
)

# 3) Add the Hypr binding, idempotently
mkdir -p "$(dirname "$BINDINGS_FILE")"
if [ -f "$BINDINGS_FILE" ]; then
  if ! grep -Fxq "$BIND_LINE" "$BINDINGS_FILE"; then
    echo "$BIND_LINE" >> "$BINDINGS_FILE"
  fi
else
  echo "$BIND_LINE" > "$BINDINGS_FILE"
fi

# 4) Finish message
echo "✅ Installation complete! 🎉"
