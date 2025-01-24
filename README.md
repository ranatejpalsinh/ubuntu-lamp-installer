# Setup Ubuntu Script

## Overview
This Bash script automates the installation and configuration of a web development environment on an Ubuntu server. It installs and configures the following components:

- **Apache2** (Web Server)
- **MySQL** (Database Server)
- **PHP** (with user-specified version and extensions)
- **phpMyAdmin** (Database Management Tool)

The script also handles:
- Setting the MySQL root password.
- Creating a new MySQL user (optional).
- Configuring PHP as the default version.
- Enabling Apache2 modules and firewall settings.

## Features
- Prompts the user to specify the PHP version to install.
- Allows optional configuration of MySQL root password and a custom MySQL user.
- Automates the setup of a secure MySQL installation.
- Provides status messages for each step of the installation process.

## Prerequisites
- An Ubuntu-based system with `sudo` privileges.
- A stable internet connection.

## How to Run

1. **Download the Script**
   Save the `setup_ubuntu.sh` file to your system.

2. **Make the Script Executable**
   Run the following command to make the script executable:
   ```bash
   chmod +x setup_ubuntu.sh
   ```

3. **Run the Script**
   Execute the script using the following command:
   ```bash
   ./setup_ubuntu.sh
   ```

4. **Follow the Prompts**
   - Enter the PHP version to install (e.g., `7.4`, `8.0`, `8.1`).
   - Optionally, provide the MySQL root password and custom MySQL user details.

5. **Access Your Environment**
   - After the script completes, you can access phpMyAdmin at: `http://localhost/phpmyadmin`.

## Usage Examples
### Install PHP 8.1 with Default MySQL Root Password:
```bash
./setup_ubuntu.sh
Enter the PHP version you want to install (e.g., 7.4, 8.0, 8.1, etc.): 8.1
Enter MySQL root password (leave blank for default root password):
```

### Install PHP 7.4 with Custom MySQL Root Password and New User:
```bash
./setup_ubuntu.sh
Enter the PHP version you want to install (e.g., 7.4, 8.0, 8.1, etc.): 7.4
Enter MySQL root password (leave blank for default root password): mysecurepassword
Enter MySQL username for a new user (e.g., myuser), or press Enter to skip: myuser
Enter MySQL password for myuser: myuserpassword
```

## Script Details
### Steps Performed:
1. Updates and upgrades the system packages.
2. Installs and configures Apache2.
3. Installs and configures MySQL, including:
   - Setting the root password.
   - Automating secure installation steps.
   - Creating an optional custom MySQL user with privileges.
4. Adds the PHP repository and installs the specified PHP version with commonly used extensions.
5. Installs phpMyAdmin and enables the Apache rewrite module.
6. Configures the selected PHP version as the default.
7. Restarts Apache and configures the firewall for Apache traffic.

## Troubleshooting
- Ensure you have `sudo` privileges before running the script.
- If phpMyAdmin is not accessible, ensure Apache is running and the firewall allows traffic:
  ```bash
  sudo systemctl status apache2
  sudo ufw status
  ```
- If the PHP version is not recognized, verify the PPA repository and package availability.

## License
This script is open-source and can be used or modified freely.

## Contribution
Feel free to submit issues or enhancements for the script. Contributions are always welcome!
