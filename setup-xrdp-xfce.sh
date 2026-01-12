#!/bin/bash

# =================================================================
#         XRDP with XFCE, LibreOffice, and VS Code Setup
# =================================================================
#
# This script automates the setup of a complete remote desktop
# environment on Ubuntu 22.04.
#
# Features:
# - Installs XFCE, a lightweight desktop environment
# - Configures XRDP for remote access
# - Installs Firefox, Chromium, LibreOffice, and VS Code
# - Creates a new user with optional sudo privileges
# - Sets up UFW firewall rules for SSH and RDP
#
# =================================================================

# --- Configuration and Constants ---
# Default username if none is provided
readonly DEFAULT_USERNAME="kogulan"
# RDP port
readonly RDP_PORT=3389
# SSH port
readonly SSH_PORT=22

# --- Helper Functions ---
# Function to display an error message and exit
error_exit() {
  echo "❌ Error: $1" >&2
  exit 1
}

# Function to print a separator line for better readability
print_separator() {
  echo "================================================================"
}

# --- Main Logic ---

# Function to display a welcome message and installation summary
show_welcome_message() {
  echo "👋 Welcome to the Ubuntu Remote Desktop Setup Script!"
  print_separator
  echo "This script will install and configure a complete XFCE remote desktop environment."
  echo
  echo "Software to be installed:"
  echo "  - XFCE Desktop Environment"
  echo "  - XRDP for remote access"
  echo "  - Firefox and Chromium browsers"
  echo "  - LibreOffice Suite"
  echo "  - Visual Studio Code"
  print_separator
  read -p "Do you want to continue? (y/n) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    error_exit "Installation cancelled by user."
  fi
}

# Function to clean up previously installed conflicting packages
cleanup() {
  echo "[*] Cleaning up any conflicting desktop environment packages..."

  # List of packages to check and remove
  local packages_to_remove=(
    ubuntu-mate-core ubuntu-mate-desktop ubuntu-desktop
    xfce4 xfce4-goodies lxde lxqt cinnamon-desktop-environment
    kde-plasma-desktop xrdp firefox chromium-browser libreoffice-core code
  )

  # Check which packages are installed and purge them
  local packages_to_purge=()
  for pkg in "${packages_to_remove[@]}"; do
    if dpkg -s "$pkg" &>/dev/null; then
      packages_to_purge+=("$pkg")
    fi
  done

  if [ ${#packages_to_purge[@]} -gt 0 ]; then
    echo "Removing the following packages: ${packages_to_purge[*]}"
    sudo apt-get purge -y "${packages_to_purge[@]}" || echo "Could not remove all packages."
    sudo apt-get autoremove -y
  else
    echo "No conflicting packages found to remove."
  fi

  sudo apt-get autoclean
}

# Function to install all necessary packages for the remote desktop
install_packages() {
  echo "[*] Updating system and installing required packages..."
  sudo apt-get update && sudo apt-get upgrade -y || error_exit "System update failed."

  local packages_to_install=(
    xfce4
    xfce4-goodies
    xrdp
    firefox
    chromium-browser
    libreoffice
  )

  echo "Installing: ${packages_to_install[*]}"
  sudo apt-get install -y "${packages_to_install[@]}" || error_exit "Package installation failed."

  # VS Code is installed separately as it requires adding a repository
  install_vscode
}

# Function to install Visual Studio Code
install_vscode() {
  echo "[*] Installing Visual Studio Code..."
  if ! command -v code &>/dev/null; then
    # Add Microsoft GPG key and repository
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null

    # Install VS Code
    sudo apt-get update
    sudo apt-get install -y code || error_exit "VS Code installation failed."

    # Clean up the GPG key file
    rm -f packages.microsoft.gpg
  else
    echo "Visual Studio Code is already installed."
  fi
}

# Function to configure XRDP to use the XFCE session
configure_xrdp() {
  echo "[*] Configuring XRDP to use the XFCE session..."

  # Set XFCE as the default session for the current user
  if [ ! -f ~/.xsession ] || ! grep -q "startxfce4" ~/.xsession; then
    echo "startxfce4" >~/.xsession
  fi

  # Allow any user to start a session (required for XRDP)
  if ! sudo grep -q "allowed_users=anybody" /etc/X11/Xwrapper.config; then
    sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
  fi

  # Enable and restart the XRDP service
  echo "Enabling and restarting XRDP service..."
  sudo systemctl enable xrdp && sudo systemctl restart xrdp || error_exit "XRDP configuration failed."
}

# Function to create a new user for RDP access
create_user() {
  local username=$1
  echo "[*] Creating user '$username' for RDP access..."

  if id "$username" &>/dev/null; then
    echo "User '$username' already exists. Skipping user creation."
  else
    # Create the user with an empty password (will be prompted to set one)
    sudo adduser --gecos "" --disabled-password "$username" || error_exit "User creation failed."
    echo "Please set a password for the new user '$username'."
    sudo passwd "$username" || error_exit "Password setup failed."

    # Ask whether to grant sudo access
    read -p "Grant sudo (administrator) privileges to '$username'? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo "Adding '$username' to the sudo group."
      sudo usermod -aG sudo "$username"
    else
      echo "User '$username' will not have sudo privileges."
    fi
  fi
}

# Function to set up the firewall to allow RDP and SSH traffic
configure_firewall() {
  echo "[*] Setting up UFW firewall rules..."

  # Allow RDP traffic
  if ! sudo ufw status | grep -q "${RDP_PORT}/tcp"; then
    echo "Allowing RDP traffic on port ${RDP_PORT}..."
    sudo ufw allow "${RDP_PORT}/tcp"
  fi

  # Allow SSH traffic
  if ! sudo ufw status | grep -q "${SSH_PORT}/tcp"; then
    echo "Allowing SSH traffic on port ${SSH_PORT}..."
    sudo ufw allow "${SSH_PORT}/tcp"
  fi

  # Enable the firewall if it's not already active
  if ! sudo ufw status | grep -q "Status: active"; then
    echo "Enabling the UFW firewall..."
    sudo ufw --force enable
  else
    echo "UFW is already active."
  fi
}

# --- Main Execution ---
main() {
  # Prompt for the username, defaulting to the value of DEFAULT_USERNAME
  read -p "Enter the username for the new RDP user [${DEFAULT_USERNAME}]: " username
  local final_username=${username:-$DEFAULT_USERNAME}

  show_welcome_message
  cleanup
  install_packages
  configure_xrdp
  create_user "$final_username"
  configure_firewall

  # --- Final Output ---
  local ip_address
  ip_address=$(curl -s ifconfig.me)

  print_separator
  echo "✅ Setup Complete!"
  echo "Your remote desktop is ready."
  print_separator
  echo "  🌐 Web browsers: Firefox, Chromium"
  echo "  📝 Office suite: LibreOffice"
  echo "  💻 Editor: Visual Studio Code"
  echo "  🔐 Login with username: $final_username"
  echo "  💻 Connect using your RDP client to: $ip_address:$RDP_PORT"
  print_separator
}

# Run the main function only when executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main
fi
