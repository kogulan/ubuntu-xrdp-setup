# 🖥️ Ubuntu Remote Desktop Setup Script (XFCE + XRDP + VS Code + LibreOffice)

This Bash script automates the setup of a **lightweight Ubuntu desktop environment** with **XRDP remote access**, browsers, productivity tools, and firewall rules on **Ubuntu 22.04**.

## 🚀 Features

- Installs the XFCE desktop environment (lightweight and fast)
- Sets up XRDP for Remote Desktop access
- Installs:
  - Firefox and Chromium web browsers
  - LibreOffice suite
  - Visual Studio Code
- Creates a new sudo user for RDP access
- Configures firewall (UFW) for SSH and RDP
- Cleans up unnecessary desktop packages

---

## 📋 Prerequisites

- Ubuntu 22.04 (fresh installation recommended)
- Internet connection
- Run as a user with `sudo` privileges

---

## 🛠️ How to Use

### 1. Clone or Download

```bash
git clone https://github.com/kogulan/ubuntu-xrdp-setup.git
```
```bash
cd ubuntu-xrdp-setup
```

Or simply download and run the script:

```bash
wget https://yourdomain.com/setup-xrdp-xfce.sh
```
```bash
chmod +x setup-xrdp-xfce.sh
```

### 2. Edit Configuration (Optional)

At the top of the script, you can set a custom username and password for the new RDP user:

```bash
USERNAME="kogulan"               # Change to your preferred username
PASSWORD="StrongPass123"         # Change to a strong password
```

> 💡 **Security Tip:** Avoid hardcoding passwords. You can remove `PASSWORD` and let `adduser` prompt for it interactively.

---

### 3. Run the Script

```bash
sudo ./setup-xrdp-xfce.sh
```

The script will:
- Clean existing desktop environments
- Install XFCE, XRDP, browsers, office suite, and VS Code
- Create a new RDP user
- Set up the firewall
- Display the public IP and login credentials

---

## 🖥️ Remote Desktop Login

Use any RDP client (like **Remote Desktop Connection** on Windows or **Remmina** on Linux/macOS):

- **Host/IP:** (shown at the end of the script)  
- **Port:** `3389`
- **Username:** `kogulan` (or your custom value)
- **Password:** `StrongPass123` (or your custom value)

Example:

```text
Username: kogulan
Password: StrongPass123
RDP Address: 203.0.113.15:3389
```

---

## 🔒 Security Warning

**Do not use weak passwords** for remote access. It’s strongly recommended to:

- Use SSH key-based login instead of passwords (for SSH)
- Change the password after logging in
- Use fail2ban or other brute-force protection if exposed to the internet

---

## 🧹 Uninstallation (Optional)

To remove all installed components:

```bash
sudo apt purge -y xfce4 xfce4-goodies xrdp firefox chromium libreoffice code
sudo apt autoremove -y
```

---

## 📄 Example Output

```
[*] Cleaning up previously installed desktop environments...
[*] Updating system...
[*] Installing XFCE Desktop Environment...
[*] Installing XRDP...
[*] Creating user 'kogulan'...
[*] Installing Firefox and Chromium browsers...
[*] Installing LibreOffice office suite...
[*] Installing Visual Studio Code...
[*] Setting up UFW firewall rules...

✅ XRDP with XFCE, LibreOffice, and VS Code is ready on Ubuntu 22.04!
🌐 Browsers: Firefox, Chromium
📝 Office: LibreOffice
💻 Editor: Visual Studio Code
🔐 RDP Login: kogulan / StrongPass123
🌍 Connect: 203.0.113.15:3389
```

---

## 📦 Tested On

- ✅ Ubuntu 22.04 LTS (64-bit)

---

## 📬 Issues & Contributions

Feel free to open an issue or submit a pull request to improve the script or add support for additional configurations!

---

## 🧑‍💻 Author

**Kogulan**  
Feel free to customize and use in your own deployment workflows.

---
