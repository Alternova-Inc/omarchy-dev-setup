# 🚀 Alternova Development Environment Installer

Welcome to the **Alternova Development Environment Installer**! This suite of scripts sets up a fully configured development environment specifically for **Omarchy (Arch Linux)**, including essential tools, security agents, and productivity software. Perfect for Alternova developers who want to get up and running quickly with all the necessary components on their Omarchy systems.

## 📦 What's Included

This installer includes the following components:

### 🛠️ Main Installer (`install.sh`)

- **System Updates**: Updates all packages to the latest versions
- **Yay AUR Helper**: Installs the Yay AUR helper for easy package management
- **Visual Studio Code**: Installs VS Code with all extensions for development
- **Theme Installation**: Sets up the custom Alternity theme for a beautiful development experience

### 🔒 Fleet Agent (`fleet.sh`)

- **Osquery Installation**: Installs osquery (via AUR) for system monitoring
- **Fleet Configuration**: Configures osquery to connect to the Fleet server at `fleet.alternova.dev`
- **TLS Certificate Handling**: Automatically fetches and configures TLS certificates for secure communication
- **Service Management**: Enables and starts the osqueryd service for continuous monitoring

### 🛡️ Drata Agent (`drata-agent.sh`)

- **AppImage Setup**: Configures the Drata Agent AppImage for workstation security monitoring
- **Desktop Integration**: Creates desktop entries and icons for easy access
- **URI Handler Registration**: Registers the `auth-drata-agent://` scheme for seamless authentication
- **Icon Download**: Downloads the official Drata logo for the desktop integration

## 🚀 Quick Start

1. **Clone or Download** the scripts to your local machine
2. **Make Scripts Executable**:
   ```bash
   chmod +x install.sh fleet.sh drata-agent.sh
   ```
3. **Run the Main Installer**:
   ```bash
   ./install.sh
   ```
4. **Follow Prompts**: Enter the Fleet enroll secret when prompted during the Fleet setup

## 📋 Detailed Installation Steps

### Step 1: System Preparation

- Updates all system packages using `pacman -Syu`
- Installs base development tools (git, base-devel)

### Step 2: Yay Installation

- Downloads Yay from the AUR
- Builds and installs Yay in a temporary directory (`/tmp/yay`)
- Cleans up installation files automatically

### Step 3: Fleet Agent Setup

- Prompts for the Fleet enroll secret (keep this secure!)
- Installs osquery via Yay (or builds from AUR if Yay is unavailable)
- Configures osquery with Fleet server settings
- Sets up TLS certificates for secure communication
- Enables and starts the osqueryd service

### Step 4: Drata Agent Setup

- Locates the Drata-Agent.AppImage (expects it in current directory or `~/Downloads/`)
- Moves AppImage to `~/.local/opt/drata/`
- Downloads the Drata logo for desktop integration
- Creates desktop entry with URI handler support
- Registers the authentication scheme

### Step 5: VS Code Installation

- Installs Visual Studio Code via Yay
- Ready for development work!

### Step 6: Theme Installation

- Installs the custom Alternity theme for a branded experience

## 🔧 Extra Steps & Verification

### Fleet Agent Verification

After installation, you can verify the Fleet agent is working:

- Check service status: `sudo systemctl status osqueryd`
- View logs: `sudo journalctl -u osqueryd`
- In the Fleet web UI, your machine should appear in the Hosts section shortly

### Drata Agent Verification

To test the Drata agent setup:

1. **Sanity Check**: Run `xdg-mime query default x-scheme-handler/auth-drata-agent`
   - Should output: `drata-agent.desktop`
2. **Test URI Handler**: Run `xdg-open 'auth-drata-agent://test'`
   - Should open the Drata Agent application
3. **Web UI Connection**: Go back to the Drata web interface and click "Connect Device"

### Troubleshooting

- If Yay installation fails, ensure you have `git` and `base-devel` installed
- For Fleet connection issues, verify the enroll secret and network connectivity
- Drata AppImage must be present before running the setup script

## 🔒 Security Notes

- The Fleet enroll secret is sensitive - store it securely and never commit to version control
- All scripts use `sudo` for system-level operations - you'll be prompted for your password once at the start
- TLS certificates are automatically handled for secure Fleet communication

## 🎉 You're All Set!

Once installation completes, you'll have a fully configured development environment with:

- ✅ Updated system packages
- ✅ AUR access via Yay
- ✅ Fleet monitoring agent running
- ✅ Drata security agent configured
- ✅ VS Code ready for coding
- ✅ Custom Alternity theme applied

## Other configuration guides

You can check out our [guides directory](./guides) where you will find additional configurations that have been useful for our teams.

Happy coding! 🚀
