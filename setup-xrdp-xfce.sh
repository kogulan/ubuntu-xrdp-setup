#!/bin/bash

# === Configuration ===
USERNAME="kogulan"               # Change to your preferred username
PASSWORD="StrongPass123"         # Change to a strong password

# === Cleanup Previously Installed Desktops and XRDP ===
echo "[*] Cleaning up previously installed desktop environments and XRDP..."
sudo apt purge -y ubuntu-mate-core ubuntu-mate-desktop ubuntu-desktop xfce4 lxde lxqt cinnamon-desktop-environment kde-plasma-desktop xrdp
sudo apt autoremove -y
sudo apt autoclean

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

# === Install Web Browsers ===
echo "[*] Installing Firefox and Chromium browsers..."
sudo apt update
sudo apt install -y firefox chromium-browser

# === Configure Firewall ===
echo "[*] Setting up UFW firewall rules..."
sudo ufw allow 3389/tcp
sudo ufw allow ssh
sudo ufw --force enable

# === Final Output ===
IP=$(curl -s ifconfig.me)
echo ""
echo "====================================================="
echo "✅ XRDP with XFCE is ready on Ubuntu 22.04!"
echo "🌐 Web browsers installed:"
echo "   - Firefox (Default Browser)"
echo "   - Chromium"
echo "🔐 Login with:"
echo "   - Username: $USERNAME"
echo "   - Password: $PASSWORD"
echo "💻 RDP Client: Connect to $IP:3389"
echo "🔒 REMINDER: Change the password after logging in!"
echo "====================================================="
