
# Ubuntu XRDP with XFCE, Firefox, and Chrome/Chromium Setup

This repository provides an automated script to install and configure **XRDP** with the **XFCE desktop environment** on **Ubuntu 22.04 LTS**. It also installs the latest versions of **Firefox** and **Google Chrome** (or Chromium as fallback). Ideal for cloud VMs like those on **Oracle Cloud Infrastructure (OCI)**, **AWS**, or **Azure**.

---

## 🧰 Features

- Removes old desktop environments
- Installs **XFCE4** desktop environment
- Installs and configures **XRDP**
- Creates a new user with RDP access
- Installs **Firefox** (APT version, no Snap)
- Installs **Google Chrome** (falls back to **Chromium** if Chrome fails)
- Opens required ports (RDP & SSH)
- Enables **UFW** firewall

---

## 🚀 Prerequisites

- Ubuntu 22.04 LTS virtual machine
- Outbound internet access from the VM
- Inbound port **3389** open (in OCI Security List or NSG)
- SSH access to the VM

---

## 🔧 Installation Steps

### 1. SSH into your Ubuntu 22.04 VM

```bash
ssh -i /path/to/private_key.pem ubuntu@<your_vm_ip>
```

### 2. Clone this repository

```bash
git clone https://github.com/<your-github-username>/ubuntu-xrdp-setup.git
cd ubuntu-xrdp-setup
```

### 3. Make the script executable

```bash
chmod +x setup-xrdp-xfce.sh
```

### 4. Run the script

```bash
./setup-xrdp-xfce.sh
```

The script will:

- Install XFCE desktop environment
- Install and configure XRDP
- Create a user (default: `kogulan`, password: `StrongPass123`)
- Install Firefox and Google Chrome (or Chromium as fallback)
- Configure the firewall for SSH and RDP access

---

## 💻 How to Connect via RDP

Use an RDP client from **Windows**, **macOS**, or **Linux**:

- **RDP Host**: `your_vm_ip:3389`
- **Username**: `kogulan`
- **Password**: `StrongPass123`

> 🔐 It is strongly recommended to change the password after logging in:
> ```bash
> sudo passwd kogulan
> ```

---

## 🔒 Security Hardening Tips

- **Restrict RDP to your IP** (optional):
  ```bash
  sudo ufw deny 3389
  sudo ufw allow from <your.ip.address.here> to any port 3389 proto tcp
  ```

- **Install fail2ban** (to protect SSH and XRDP from brute-force attacks):
  ```bash
  sudo apt install -y fail2ban
  ```

- **Disable the default user or rename it** if not needed.

---

## 🧹 To Uninstall Everything

```bash
sudo apt purge -y xrdp xfce4 xfce4-goodies firefox chromium-browser google-chrome-stable
sudo apt autoremove -y
sudo apt autoclean
```

---

## 📂 Repository Structure

```
ubuntu-xrdp-setup/
├── setup-xrdp-xfce.sh
└── README.md
```

---

## 📝 License

This project is licensed under the [MIT License](LICENSE).

---

## 🙋 Support

If you encounter issues, please [open an issue](https://github.com/<your-github-username>/ubuntu-xrdp-setup/issues).
