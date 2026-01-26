#!/bin/bash
# ============================================================
# XRDP + XFCE + Apps + Fonts setup
# Ubuntu 24.04 ARM64
# ============================================================

set -e

USERNAME="kogulan"
RDP_PORT=3389
SSH_PORT=22

# --- OS check ---
[[ "$(lsb_release -rs)" == "24.04" ]] || { echo "Ubuntu 24.04 required"; exit 1; }

# --- Update system ---
sudo apt update && sudo apt upgrade -y

# --- Base packages ---
sudo apt install -y \
  xfce4 xfce4-goodies xrdp ufw \
  wget curl gnupg software-properties-common \
  apt-transport-https

# --- XRDP config ---
sudo sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/X11/Xwrapper.config
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# --- User setup ---
id "$USERNAME" &>/dev/null || sudo adduser --gecos "" "$USERNAME"
HOME_DIR=$(getent passwd "$USERNAME" | cut -d: -f6)
echo "startxfce4" | sudo tee "$HOME_DIR/.xsession" > /dev/null
sudo chown "$USERNAME:$USERNAME" "$HOME_DIR/.xsession"

# --- Applications ---
sudo apt install -y firefox libreoffice chromium-browser

# VS Code (ARM64)
VSCODE_DEB="/tmp/vscode-arm64.deb"
wget -qO "$VSCODE_DEB" https://update.code.visualstudio.com/latest/linux-deb-arm64/stable
sudo apt install -y "$VSCODE_DEB"
rm -f "$VSCODE_DEB"

# --- Fonts ---
sudo apt install -y \
  fonts-noto-core \
  fonts-noto-extra \
  fonts-noto-ui-core \
  fonts-noto-color-emoji \
  fonts-dejavu-core \
  fonts-freefont-ttf \
  fonts-liberation

# --- Firewall ---
sudo ufw allow ${SSH_PORT}/tcp
sudo ufw allow ${RDP_PORT}/tcp
sudo ufw --force enable

# --- Info ---
IP=$(curl -s ifconfig.me)
echo "XRDP ready"
echo "User: $USERNAME"
echo "RDP: $IP:$RDP_PORT"
echo "Setup complete"
