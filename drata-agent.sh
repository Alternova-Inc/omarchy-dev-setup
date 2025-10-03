#!/usr/bin/env bash
set -e

# ==========================
# Drata Agent Setup Script
# Arch Linux (AppImage + URI handler)
# ==========================

APPDIR="$HOME/.local/opt/drata"
APPIMG="$APPDIR/Drata-Agent.AppImage"
DESKTOP_DIR="$HOME/.local/share/applications"
ICON_DIR="$HOME/.local/share/icons/hicolor/256x256/apps"
DESKTOP_FILE="$DESKTOP_DIR/drata-agent.desktop"
MIMEAPPS_FILE="$DESKTOP_DIR/mimeapps.list"
ICON_FILE="$ICON_DIR/drata-agent.png"

# echo ">>> Setting up Drata Agent AppImage integration..."

# 1. Ensure directories exist
mkdir -p "$APPDIR" "$DESKTOP_DIR" "$ICON_DIR"

# 2. Move AppImage into place (expects file in current dir or Downloads)
if [ -f "./Drata-Agent.AppImage" ]; then
  mv ./Drata-Agent.AppImage "$APPIMG"
elif [ -f "$HOME/Downloads/Drata-Agent.AppImage" ]; then
  mv "$HOME/Downloads/Drata-Agent.AppImage" "$APPIMG"
fi
chmod +x "$APPIMG"

# 3. Download icon
# echo ">>> Downloading Drata logo..."
curl -L "https://avatars.githubusercontent.com/u/65421071?s=256&v=4" -o "$ICON_FILE"

# 4. Create desktop entry with URI handler
# echo ">>> Creating desktop entry..."
cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Drata Agent
Comment=Drata workstation agent
Exec=$APPIMG %u
Terminal=false
Categories=Utility;Security;
Icon=drata-agent
MimeType=x-scheme-handler/auth-drata-agent;
EOF

# 5. Register URI scheme in mimeapps.list
# echo ">>> Registering URI handler..."
cat > "$MIMEAPPS_FILE" <<EOF
[Default Applications]
x-scheme-handler/auth-drata-agent=drata-agent.desktop
EOF

# 6. Refresh desktop DB
update-desktop-database "$DESKTOP_DIR"

# echo ">>> Setup complete!"
# echo "Sanity check:"
# echo "  xdg-mime query default x-scheme-handler/auth-drata-agent"
# echo "Should print: drata-agent.desktop"
# echo
# echo "Test with: xdg-open 'auth-drata-agent://test'"
# echo
# echo "If everything is good, go back to Drata web UI and click 'Connect Device'."
