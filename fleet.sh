#!/usr/bin/env bash
set -euo pipefail

### ============================
### CONFIG — EDIT ME
### ============================
FLEET_SCHEME="https"                 # "https" (recommended) or "http"
FLEET_HOST="fleet.alternova.dev"  # DNS name or IP of your Fleet server
FLEET_PORT="443"                     # 443 for https, 8080 if you use http dev port, etc.
read -s -p "Enter the Fleet enroll secret: " ENROLL_SECRET
echo  # For newline after input

# Where to store files
OSQUERY_DIR="/etc/osquery"
ENROLL_SECRET_PATH="${OSQUERY_DIR}/fleet_enroll_secret"
TLS_CERT_PATH="${OSQUERY_DIR}/fleet.pem"    # used only when FLEET_SCHEME=https
FLAGS_PATH="${OSQUERY_DIR}/osquery.flags"

### ============================
### Helpers
### ============================
need_cmd() { command -v "$1" >/dev/null 2>&1; }
as_real_user() {
  # Build AUR packages as the invoking user (not root) when possible
  if [ -n "${SUDO_USER-}" ] && [ "$SUDO_USER" != "root" ]; then
    sudo -u "$SUDO_USER" bash -c "$*"
  else
    bash -c "$*"
  fi
}

# echo "==> Fleet client (osquery) installer for Arch Linux"

### 1) Prereqs
# echo "==> Installing prerequisites"
sudo pacman -Sy --needed --noconfirm git base-devel

### 2) Install osquery from AUR (if not installed)
if need_cmd osqueryd; then
  # echo "==> osqueryd already installed, skipping AUR build"
  :
else
  if need_cmd yay; then
    # echo "==> Installing osquery via yay"
    as_real_user "yay -S --noconfirm osquery"
  elif need_cmd paru; then
    # echo "==> Installing osquery via paru"
    as_real_user "paru -S --noconfirm osquery"
  else
    # echo "==> No AUR helper found; building osquery directly from AUR"
    WORKDIR="$(mktemp -d)"
    trap 'rm -rf "$WORKDIR"' EXIT
    as_real_user "git clone https://aur.archlinux.org/osquery.git \"$WORKDIR/osquery\""
    pushd "$WORKDIR/osquery" >/dev/null
    # makepkg must run as non-root by design; we use as_real_user
    as_real_user "cd \"$WORKDIR/osquery\" && makepkg -si --noconfirm"
    popd >/dev/null
  fi
fi

### 3) Create /etc/osquery and write enroll secret
# echo "==> Configuring osquery for Fleet"
sudo install -d -m 0755 "$OSQUERY_DIR"
printf "%s\n" "$ENROLL_SECRET" | sudo tee "$ENROLL_SECRET_PATH" >/dev/null
sudo chmod 600 "$ENROLL_SECRET_PATH"

TLS_HOSTNAME="${FLEET_HOST}:${FLEET_PORT}"
FLEET_BASE="${FLEET_SCHEME}://${FLEET_HOST}:${FLEET_PORT}"

### 4) If HTTPS, fetch Fleet TLS cert (self-signed or custom CA)
INSECURE_FLAG=""
TLS_CERT_LINE=""
if [ "$FLEET_SCHEME" = "https" ]; then
  # echo "==> Fetching Fleet TLS certificate to ${TLS_CERT_PATH}"
  # If your Fleet uses a public CA (Let's Encrypt, etc.), this step is optional,
  # but harmless. For self-signed, it’s required.
  openssl s_client -servername "$FLEET_HOST" -connect "${FLEET_HOST}:${FLEET_PORT}" -showcerts </dev/null 2>/dev/null \
    | openssl x509 -outform PEM | sudo tee "$TLS_CERT_PATH" >/dev/null || true
  sudo chmod 644 "$TLS_CERT_PATH"
  TLS_CERT_LINE="--tls_server_certs=${TLS_CERT_PATH}"
else
  # echo "==> Using HTTP (dev). Enabling --insecure."
  INSECURE_FLAG="--insecure"
  TLS_CERT_LINE=""  # not used on http
fi

### 5) Write osquery flags
# echo "==> Writing ${FLAGS_PATH}"
sudo tee "$FLAGS_PATH" >/dev/null <<EOF
--tls_hostname=${TLS_HOSTNAME}
--enroll_secret_path=${ENROLL_SECRET_PATH}
${TLS_CERT_LINE}
--enroll_tls_endpoint=/api/osquery/enroll
--config_plugin=tls
--config_tls_endpoint=/api/osquery/config
--logger_plugin=tls
--logger_tls_endpoint=/api/osquery/log
--disable_distributed=false
--tls_session_reuse=true
${INSECURE_FLAG}
EOF
# Clean blank lines (in case TLS_CERT_LINE is empty)
sudo sed -i '/^$/d' "$FLAGS_PATH"
sudo chmod 644 "$FLAGS_PATH"

### 6) Enable and start service
# echo "==> Enabling and starting osqueryd"
sudo systemctl enable osqueryd
sudo systemctl restart osqueryd

### 7) Quick status + test enroll
# echo "==> osqueryd status (last lines):"
sudo systemctl --no-pager -l status osqueryd | tail -n 25 || true

# echo "==> Running a quick enroll check (osqueryd runs in background)"
sleep 3

# echo "==> Done. In the Fleet UI, check Hosts → your Arch machine should appear shortly."
