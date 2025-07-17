#!/bin/bash

# === Configuration ===
# Prompt for the username, defaulting to "kogulan"
read -p "Enter the username for the new RDP user [kogulan]: " USERNAME
USERNAME=${USERNAME:-kogulan}

# --- Helper Functions ---
# Function to display error and exit
error_exit() {
  echo "❌ Error: $1" >&2
  exit 1
}

# Function to print a separator line
print_separator() {
  echo "=============================================="
}

# --- Main Logic ---
# Function to display a welcome message and summary
show_welcome_message() {
  echo "👋 Welcome to the Ubuntu Remote Desktop Setup Script!"
  print_separator
  echo "This script will install and configure a complete"
  echo "XFCE remote desktop environment."
  echo ""
  echo "The following software will be installed:"
  echo " - XFCE Desktop Environment"
  echo " - XRDP for remote access"
  echo " - Firefox and Chromium browsers"
  echo " - LibreOffice Suite"
  echo " - Visual Studio Code"
  print_separator
  read -p "Do you want to continue? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    error_exit "Installation cancelled by user."
  fi
}

# Function to clean up previously installed packages
cleanup() {
  echo "[*] Cleaning up any conflicting packages..."
  sudo apt purge -y \
    ubuntu-mate-core ubuntu-mate-desktop ubuntu-desktop \
    xfce4 xfce4-goodies lxde lxqt cinnamon-desktop-environment \
    kde-plasma-desktop xrdp firefox chromium-browser libreoffice code &>/dev/null || echo "No packages to remove."
  sudo apt autoremove -y &>/dev/null
  sudo apt autoclean &>/dev/null
}

# Function to install all necessary packages
install_packages() {
  echo "[*] Updating system and installing packages..."
  sudo apt-get update && sudo apt-get upgrade -y || error_exit "System update failed."

  local packages_to_install=(
    xfce4
    xfce4-goodies
    xrdp
    firefox
    chromium-browser
    libreoffice
  )

  sudo apt-get install -y "${packages_to_install[@]}" || error_exit "Package installation failed."

  # Install VS Code separately as it requires adding a new repository
  install_vscode
}

# Function to install Visual Studio Code
install_vscode() {
  echo "[*] Installing Visual Studio Code..."
  if ! command -v code &> /dev/null; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt-get update
    sudo apt-get install -y code || error_exit "VS Code installation failed."
    rm -f packages.microsoft.gpg
  else
    echo "Visual Studio Code is already installed."
  fi
}

# Function to configure XRDP and XFCE
configure_xrdp() {
  echo "[*] Configuring XRDP to use the XFCE session..."
  # Set XFCE as the default session for the current user
  if [ ! -f ~/.xsession ] || ! grep -q "startxfce4" ~/.xsession; then
    echo "startxfce4" >~/.xsession
  fi

  # Allow anyone to start a session
  if ! sudo grep -q "allowed_users=anybody" /etc/X11/Xwrapper.config; then
    sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
  fi

  # Enable and restart XRDP
  sudo systemctl enable xrdp && sudo systemctl restart xrdp || error_exit "XRDP configuration failed."
}

# Function to create a new user
create_user() {
  echo "[*] Creating user '$USERNAME' for RDP access..."
  if id "$USERNAME" &>/dev/null; then
    echo "User '$USERNAME' already exists. Skipping user creation."
  else
    sudo adduser --gecos "" --disabled-password "$USERNAME" || error_exit "User creation failed."
    echo "Please set a password for the new user '$USERNAME'."
    sudo passwd "$USERNAME" || error_exit "Password setup failed."
    sudo usermod -aG sudo "$USERNAME"
  fi
}

# Function to set up the firewall
configure_firewall() {
  echo "[*] Setting up UFW firewall rules..."
  if ! sudo ufw status | grep -q "3389/tcp"; then
    sudo ufw allow 3389/tcp # RDP
  fi
  if ! sudo ufw status | grep -q "22/tcp"; then
    sudo ufw allow 22/tcp   # SSH
  fi
  sudo ufw --force enable
}

# Main execution function
main() {
  show_welcome_message
  cleanup
  install_packages
  configure_xrdp
  create_user
  configure_firewall

  # Final Output
  IP=$(curl -s ifconfig.me)
  print_separator
  echo "✅ Setup Complete!"
  echo "Your remote desktop is ready."
  print_separator
  echo "🌐 Web browsers: Firefox, Chromium"
  echo "📝 Office suite: LibreOffice"
  echo "💻 Editor: Visual Studio Code"
  echo "🔐 Login with username: $USERNAME"
  echo "💻 Connect using your RDP client to: $IP:3389"
  print_separator
}

# Run the main function
main
