#!/bin/bash

# === Configuration ===
USERNAME="kogulan"               # Change to your preferred username
PASSWORD="StrongPass123"         # Change to a strong password

# === Cleanup Previously Installed Packages ===
echo "[*] Cleaning up previously installed desktop environments and software..."
sudo apt purge -y \
  ubuntu-mate-core ubuntu-mate-desktop ubuntu-desktop \
  xfce4 xfce4-goodies lxde lxqt cinnamon-desktop-environment \
  kde-plasma-desktop xrdp firefox chromium-browser libreoffice code
sudo apt autoremove -y
sudo apt autoclean

# === List Software to be Installed ===
echo ""
echo "=============================================="
echo "The following software will be installed:"
echo " - XFCE desktop environment"
echo " - XRDP remote desktop server"
echo " - Firefox browser"
echo " - Chromium browser"
echo " - LibreOffice suite"
echo " - Visual Studio Code"
echo "=============================================="
echo ""

# === System Update ===
echo "[*] Updating system..."
sudo apt update && sudo apt upgrade -y

# === Install XFCE Desktop ===
echo "[*] Installing XFCE Desktop Environment..."
sudo apt install -y xfce4 xfce4-goodies

# === Install XRDP ===
echo "[*] Installing XRDP..."
sudo apt install -y xrdp
sudo systemctl enable xrdp
sudo systemctl start xrdp

# === Configure XRDP to use XFCE ===
echo "[*] Setting XFCE as the default desktop session..."
echo "startxfce4" > ~/.xsession
sudo sed -i 's/console/anybody/' /etc/X11/Xwrapper.config
sudo systemctl restart xrdp

# === Create New User for RDP ===
echo "[*] Creating user '$USERNAME'..."
sudo adduser --gecos "" --disabled-password "$USERNAME"
echo "$USERNAME:$PASSWORD" | sudo chpasswd
sudo usermod -aG sudo "$USERNAME"

# === Install Browsers ===
echo "[*] Installing Firefox and Chromium browsers..."
sudo apt install -y firefox chromium-browser

# === Install LibreOffice ===
echo "[*] Installing LibreOffice office suite..."
sudo apt install -y libreoffice

# === Install Visual Studio Code ===
echo "[*] Installing Visual Studio Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install -y code
rm -f packages.microsoft.gpg

# === Configure Firewall ===
echo "[*] Setting up UFW firewall rules..."
sudo ufw allow 3389/tcp
sudo ufw allow ssh
sudo ufw --force enable

# === Final Output ===
IP=$(curl -s ifconfig.me)
echo ""
echo "====================================================="
echo "✅ XRDP with XFCE, LibreOffice, and VS Code is ready on Ubuntu 22.04!"
echo "🌐 Web browsers installed:"
echo "   - Firefox"
echo "   - Chromium"
echo "📝 Office suite installed:"
echo "   - LibreOffice"
echo "💻 Editor installed:"
echo "   - Visual Studio Code"
echo "🔐 Login with:"
echo "   - Username: $USERNAME"
echo "   - Password: $PASSWORD"
echo "💻 RDP Client: Connect to $IP:3389"
echo "🔒 REMINDER: Change the password after logging in!"
echo "====================================================="
