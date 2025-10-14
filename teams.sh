#!/usr/bin/env bash
set -euo pipefail

# Microsoft Teams Web App installer for Omarchy
# 1) Download icon to ~/.local/share/applications/icons/teams.png
# 2) Install Teams with omarchy-webapp-install
# 3) Add Hypr binding to ~/.config/hypr/bindings.conf
# 4) Print completion message

APP_NAME="Teams"
APP_URL="https://teams.microsoft.com/v2/"
ICON_DIR="$HOME/.local/share/applications/icons"
ICON_PATH="$ICON_DIR/teams.png"
BINDINGS_FILE="$HOME/.config/hypr/bindings.conf"
BIND_LINE='bindd = SUPER SHIFT, T, Teams, exec, omarchy-launch-or-focus-webapp Teams "https://teams.microsoft.com/v2/"'

# Ensure icon directory exists
mkdir -p "$ICON_DIR"

# 2) Download the Teams icon
# Using -fL and retries for robustness; name it teams.png in the icons directory
curl -fL --retry 3 --retry-delay 2 \
  -o "$ICON_PATH" \
  "https://cdn.jsdelivr.net/gh/homarr-labs/dashboard-icons/png/microsoft-teams.png"

# 3) Install Teams as a web app using the specified command.
# The example expects 'teams.png' (not a full path), so run from the icon directory.
(
  cd "$ICON_DIR"
  omarchy-webapp-install "$APP_NAME" "$APP_URL" "teams.png"
)

# 5) Add the Hypr binding, idempotently
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
