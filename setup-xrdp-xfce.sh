
#!/bin/bash

# Exit on error
set -e

# Variables
USERNAME="kogulan"
PASSWORD="StrongPass123"

# Update packages
sudo apt update && sudo apt upgrade -y

# Remove previous desktop environments and xrdp if any
sudo apt purge -y ubuntu-desktop gnome-shell gdm3 kde-plasma-desktop lxde lxde-core xrdp
sudo apt autoremove -y
sudo apt autoclean

# Install XFCE and XRDP
sudo apt install -y xfce4 xfce4-goodies xrdp

# Enable XRDP
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# Create a new user
if ! id "$USERNAME" &>/dev/null; then
    sudo useradd -m -s /bin/bash "$USERNAME"
    echo "$USERNAME:$PASSWORD" | sudo chpasswd
    sudo usermod -aG sudo "$USERNAME"
fi

# Configure user session for XRDP
echo "startxfce4" | sudo tee /home/$USERNAME/.xsession
sudo chown $USERNAME:$USERNAME /home/$USERNAME/.xsession

# Allow RDP through the firewall
sudo ufw allow 3389/tcp
sudo ufw allow OpenSSH
sudo ufw --force enable

# Install Firefox via APT
sudo apt install -y firefox

# Try installing Google Chrome; fallback to Chromium if Chrome fails
wget -q -O /tmp/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
if sudo apt install -y /tmp/google-chrome.deb; then
    echo "Google Chrome installed successfully."
else
    echo "Google Chrome installation failed. Installing Chromium instead..."
    sudo apt install -y chromium-browser
fi

# Cleanup
rm -f /tmp/google-chrome.deb

echo "Setup complete. You can now connect via RDP using $USERNAME/$PASSWORD."
