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

# === Install Firefox (APT version) ===
echo "[*] Installing Firefox (APT version)..."
sudo snap remove firefox || true
sudo add-apt-repository -y ppa:mozillateam/ppa
echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox
sudo apt update
sudo apt install -y firefox

# === Attempt to Install Google Chrome ===
echo "[*] Attempting to install Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
if sudo apt install -y ./google-chrome-stable_current_amd64.deb; then
    echo "✅ Google Chrome installed successfully."
    rm google-chrome-stable_current_amd64.deb
else
    echo "⚠️ Google Chrome installation failed. Installing Chromium instead..."
    sudo apt install -y chromium-browser
    rm -f google-chrome-stable_current_amd64.deb
fi

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
echo "   - Firefox (APT version)"
echo "   - Google Chrome (or Chromium if Chrome failed)"
echo "🔐 Login with:"
echo "   - Username: $USERNAME"
echo "   - Password: $PASSWORD"
echo "💻 RDP Client: Connect to $IP:3389"
echo "🔒 REMINDER: Change the password after logging in!"
echo "====================================================="
