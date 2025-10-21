#!/usr/bin/env bash

# Version
VERSION="2.1"

# Webapps
# List from: https://github.com/basecamp/omarchy/blob/master/install/packaging/webapps.sh
DEFAULT_WEBAPPS=(
    "HEY"
    "Basecamp"
    "WhatsApp"
    "Google Photos"
    "Google Contacts"
    "Google Messages"
    "ChatGPT"
    "YouTube"
    "GitHub"
    "X"
    "Figma"
    "Discord"
    "Zoom"
)

# Function to check if app has installed
is_webapp_installed() {
    local webapp="$1"
    # Check if .desktop file exists for the webapp
    local desktop_file="$HOME/.local/share/applications/$webapp.desktop"
    [[ -f "$desktop_file" ]]
    return $?
}

# Function to get the installed web apps
get_installed_webapps() {
    for webapp in "${DEFAULT_WEBAPPS[@]}"; do
        if is_webapp_installed "$webapp"; then
            echo "$webapp"
        fi
    done
}

# Function to remove webapp from the system
remove_web_app_by_name() {
  local webapp="$1"
  local webapp_file_path="$HOME/.local/share/applications/$webapp.desktop"

  if [[ -f "$webapp_file_path" ]]; then
    rm -f -- "$webapp_file_path"
    echo "$webapp removed from the system..."
  else
    echo "Warning: $webapp_file_path not found. Skipping..."
  fi
}

# Main function
main() {
  echo '
=========================================================
                Init Script to Remove Web Apps
=========================================================
'

  readarray -t installed_webapps < <(get_installed_webapps)

  if (( ${#installed_webapps[@]} == 0 )); then
    echo "System: The user already has uninstalled the webapps"
  else
    echo "System: user has the next apps installed: ${installed_webapps[*]}"
    for webapp in "${installed_webapps[@]}"; do
      remove_web_app_by_name "$webapp"
    done
  fi

  echo '
---------------------------------------------------------
        Removing bundled desktop apps (Omarchy)
---------------------------------------------------------
'
  bash remove_signal.sh || true
  bash remove_typora.sh || true
  bash remove_libreoffice.sh || true

  echo '
=========================================================
                End Script to Remove Web Apps
=========================================================
'
}

main
