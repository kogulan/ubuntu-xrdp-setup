
# Ubuntu 22.04 RDP Setup with XFCE, Browsers, LibreOffice, and VS Code

This repository contains a setup script to configure an Ubuntu 22.04 LTS virtual machine on Oracle Cloud Infrastructure (OCI) for Remote Desktop Protocol (RDP) access with XFCE desktop environment, browsers, office suite, and VS Code.

---

## Features Installed by the Script

- **XFCE** Desktop Environment  
- **xrdp** Remote Desktop Server  
- **Firefox** Web Browser  
- **Chromium** Web Browser  
- **LibreOffice** Office Suite  
- **Visual Studio Code** Code Editor  

---

## Prerequisites

- Ubuntu 22.04 LTS VM running on Oracle Cloud Infrastructure  
- Basic knowledge of Linux command line  
- SSH access to the VM with sudo privileges  

---

## Usage Instructions

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/your-repo.git
   cd your-repo
   ```
1.1 **Example:**
   ```bash
   git clone https://github.com/kogulan/ubuntu-xrdp-setup.git
   cd ubuntu-xrdp-setup
   ```

2. **Make the setup script executable**

   ```bash
   chmod +x setup-xrdp-xfce.sh
   ```

3. **Run the setup script**

   ```bash
   ./setup-xrdp-xfce.sh
   ```

   > The script will:  
   > - Clean any previous conflicting installations  
   > - Update the system  
   > - Install XFCE desktop, xrdp, browsers, LibreOffice, and VS Code  
   > - Configure xrdp to use XFCE  
   > - Create a new user for RDP login (default username/password in script)  
   > - Configure firewall to allow RDP and SSH  
   > - Output the IP address and login details for RDP connection  

4. **Connect using an RDP client**

   - On Windows, use **Remote Desktop Connection** (`mstsc`).  
   - On macOS, use **Microsoft Remote Desktop** from the App Store.  
   - Connect to: `YOUR_VM_PUBLIC_IP:3389`  
   - Login with the username and password shown by the script output.  

---

## Important Notes

- Change the default password after first login for security.  
- Make sure your OCI security list allows inbound traffic on port `3389` for RDP.  
- The script assumes you have `sudo` privileges.  
- If you want to customize the username/password, edit the `setup-xrdp-xfce.sh` script before running.  

---

## Troubleshooting

- If RDP connection fails, verify that port 3389 is open in OCI and on the VM's firewall.  
- Ensure the xrdp service is running:

  ```bash
  sudo systemctl status xrdp
  ```

- To restart xrdp:

  ```bash
  sudo systemctl restart xrdp
  ```

---

## License

This project is licensed under the MIT License.

---

## Author

Your Name - [your.email@example.com](mailto:your.email@example.com)
