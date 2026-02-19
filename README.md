# 🖥️ Ubuntu 24.04 Remote Desktop Setup

Welcome! This repository provides easy-to-use scripts to transform your Ubuntu 24.04 LTS server into a fully functional remote desktop workstation. Whether you need a lightweight environment or a full-featured VPS setup, we've got you covered! 🚀

## 🌟 Why Use This?

Setting up a remote desktop can be tricky. These scripts automate the entire process:
- ✅ **One-Command Setup:** No need to manually install dozens of packages.
- ✅ **Lightweight & Fast:** Uses **XFCE**, a high-performance desktop environment that's perfect for servers.
- ✅ **Secure:** Automatically configures your firewall (UFW) to allow only necessary traffic.
- ✅ **Ready-to-Use:** Connect from any standard RDP client (Windows, macOS, or Linux).

## 🛠️ Choose Your Script

We offer two versions depending on your needs:

### 1. Basic Setup (`setup-xrdp-xfce.sh`)
Perfect for those who want a clean, minimal desktop environment.
- **Installs:** XFCE Desktop, XRDP.
- **Features:** Interactive user creation, optional `sudo` privileges, and cleanup of conflicting desktop environments.
- **Best for:** Most users and standard server configurations.

### 2. Full VPS Setup (`vps.sh`)
Designed for a complete workstation experience, often optimized for ARM64 environments (like Oracle Cloud or AWS Graviton).
- **Installs:** Everything in the Basic Setup PLUS:
  - **Apps:** Firefox, Chromium, VLC, LibreOffice, and Visual Studio Code (ARM64).
  - **Fonts:** A comprehensive collection of fonts for better readability and emoji support.
- **Best for:** Developers and power users who want a "ready-to-go" workspace.

## 🚀 Getting Started

### Prerequisites
- A server running **Ubuntu 24.04 LTS**.
- `sudo` access.

### Installation

1. **Download the preferred script:**
   ```bash
   wget https://raw.githubusercontent.com/kogulan/ubuntu-xrdp-setup/master/setup-xrdp-xfce.sh
   # OR
   wget https://raw.githubusercontent.com/kogulan/ubuntu-xrdp-setup/master/vps.sh
   ```

2. **Make it executable:**
   ```bash
   chmod +x setup-xrdp-xfce.sh
   # OR
   chmod +x vps.sh
   ```

3. **Run the script:**
   ```bash
   sudo ./setup-xrdp-xfce.sh
   # OR
   sudo ./vps.sh
   ```

## 💻 How to Connect

Once the script finishes, it will display your server's IP address. Use any RDP client to connect:

- **Computer/Host:** `YOUR_SERVER_IP`
- **Port:** `3389`
- **Username:** The username you chose during setup (default: `kogulan`).
- **Password:** The password you set during setup.

*Recommended Clients: Windows Remote Desktop Connection, Microsoft Remote Desktop (macOS/iOS), or Remmina (Linux).*

## 🔒 Security Tips

Stay safe while working remotely:
- 🔑 **Use Strong Passwords:** Ensure your RDP user has a complex password.
- 🛡️ **IP Whitelisting:** If possible, restrict port `3389` in UFW to only your specific IP address.
- 🔄 **Keep Updated:** Regularly run `sudo apt update && sudo apt upgrade` to stay secure.

## 🤝 Contribute & Support

We love community involvement!

- **⭐ Star the Repo:** If this script helped you, please give it a star! It helps others find the project.
- **🐛 Report Issues:** Found a bug? Open an [issue](https://github.com/kogulan/ubuntu-xrdp-setup/issues).
- **💡 Suggestions:** Have an idea for a new feature? Let us know!
- **🛠️ Contribute:** Pull requests are welcome. Feel free to help improve the scripts!

---
*Maintained with ❤️ for the Ubuntu community.*
