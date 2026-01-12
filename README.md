# 🖥️ Ubuntu Remote Desktop Setup Script (XFCE + XRDP)

This script automates the setup of a lightweight but powerful remote desktop environment on Ubuntu LTS servers. It installs the XFCE desktop, enables remote access via XRDP, and bundles essential software to create a ready-to-use workstation.

## ✨ Key Features

- **Lightweight Desktop:** Installs the XFCE Desktop Environment, which is fast and resource-friendly.
- **Remote Access:** Configures XRDP to allow connections from any standard RDP client (like Windows Remote Desktop).
- **Essential Software:** Comes pre-loaded with:
  - Web Browsers (Firefox & Chromium)
  - Office Suite (LibreOffice)
  - Code Editor (Visual Studio Code)
- **User Management:** Creates a new user account for RDP access and optionally grants administrative privileges.
- **Firewall Configuration:** Sets up basic UFW firewall rules to allow SSH and RDP traffic.

## ✅ Supported Ubuntu Versions

This script is tested and maintained for the following Ubuntu Long-Term Support (LTS) versions:

- **Ubuntu 24.04 LTS** (Noble Numbat)
- **Ubuntu 22.04 LTS** (Jammy Jellyfish)
- **Ubuntu 20.04 LTS** (Focal Fossa)
- **Ubuntu 18.04 LTS** (Bionic Beaver)

The script will exit with a warning if run on an unsupported version.

## 📋 Prerequisites

- A server running one of the supported Ubuntu LTS versions.
- An active internet connection.
- A user account with `sudo` privileges.

## 🚀 Installation & Usage

1.  **Download the Script**
    You can download the script directly to your server using `wget`:
    ```bash
    wget https://raw.githubusercontent.com/kogulan/ubuntu-xrdp-setup/main/setup-xrdp-xfce.sh
    ```

2.  **Make it Executable**
    ```bash
    chmod +x setup-xrdp-xfce.sh
    ```

3.  **Run the Script**
    Execute the script with `sudo`. It will guide you through the setup process.
    ```bash
    sudo ./setup-xrdp-xfce.sh
    ```
    You will be prompted to enter a username and set a password for the new RDP user.

## 💻 Connecting with RDP

Once the script is finished, it will display the IP address of your server. Use this information to connect with your favorite RDP client (e.g., Remote Desktop Connection on Windows).

- **Computer/Host:** Your server's IP address (e.g., `203.0.113.15`)
- **Port:** `3389` (default RDP port)
- **Username:** The username you created during setup.
- **Password:** The password you set for the RDP user.

## 🔒 Security Recommendations

For servers exposed to the internet, it is critical to implement additional security measures:

- **Use a Strong Password:** Always use a complex and unique password for your RDP user.
- **SSH Keys:** Prioritize SSH key-based authentication for your server instead of passwords.
- **Firewall Rules:** Restrict RDP access (`port 3389`) to trusted IP addresses if possible.
- **Use Fail2ban:** Install and configure `fail2ban` to protect against brute-force login attempts.

## 🧹 Uninstallation

To remove the components installed by this script, use the appropriate commands for your Ubuntu version.

**For Ubuntu 20.04, 22.04, and 24.04:**
```bash
sudo apt purge -y xfce4 xfce4-goodies xrdp firefox libreoffice code
sudo snap remove chromium
sudo apt autoremove -y
```

**For Ubuntu 18.04:**
```bash
sudo apt purge -y xfce4 xfce4-goodies xrdp firefox chromium-browser libreoffice code
sudo apt autoremove -y
```
