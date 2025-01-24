#!/bin/bash

# Function to print text in color
print_color() {
    case $1 in
        red)    echo -e "\033[31m$2\033[0m" ;;
        green)  echo -e "\033[32m$2\033[0m" ;;
        yellow) echo -e "\033[33m$2\033[0m" ;;
        blue)   echo -e "\033[34m$2\033[0m" ;;
        purple) echo -e "\033[35m$2\033[0m" ;;
        cyan)   echo -e "\033[36m$2\033[0m" ;;
        white)  echo -e "\033[37m$2\033[0m" ;;
        *)      echo -e "$2" ;;
    esac
}

# Function to print a banner with ASCII art
print_banner() {
    echo -e "\033[1;34m"
    echo "############################################################"
    echo "#                                                          #"
    echo "#  Welcome to the LAMP + PostgreSQL + pgAdmin Installer!    #"
    echo "#    This script will help you set up a full stack on Ubuntu #"
    echo "#                                                          #"
    echo "############################################################"
    echo -e "\033[0m"
}

# Header: Credits Section
print_color yellow "Script Created by: Tejpalsinh (ranatejpalsinh21@gmail.com)"
print_color yellow "Special thanks for using this script! :)"

# Call banner function
print_banner

# Prompt the user to enter the PHP version
print_color cyan "Enter the PHP version you want to install (e.g., 7.4, 8.0, 8.1, etc.):"
read PHP_VERSION

# Validate the PHP version input
if [[ ! "$PHP_VERSION" =~ ^[0-9]+\.[0-9]+$ ]]; then
    print_color red "Invalid PHP version format. Please enter a valid version (e.g., 7.4, 8.0, etc.)."
    exit 1
fi

# Prompt the user for MySQL root password (optional)
print_color cyan "Enter MySQL root password (leave blank for default root password):"
read -s MYSQL_ROOT_PASSWORD

# If root password is not provided, set it to "root" by default
if [[ -z "$MYSQL_ROOT_PASSWORD" ]]; then
    MYSQL_ROOT_PASSWORD="root"
    print_color yellow "No password provided. Using default root password: $MYSQL_ROOT_PASSWORD"
fi

# Prompt the user for MySQL username and password for a custom user
print_color cyan "Enter MySQL username for a new user (e.g., myuser), or press Enter to skip:"
read MYSQL_USER

if [[ -n "$MYSQL_USER" ]]; then
    print_color cyan "Enter MySQL password for $MYSQL_USER:"
    read -s MYSQL_PASSWORD
fi

# Prompt the user for PostgreSQL username and password
print_color cyan "Enter PostgreSQL admin username (default is 'postgres'):"
read POSTGRES_USER

if [[ -z "$POSTGRES_USER" ]]; then
    POSTGRES_USER="postgres"
fi

print_color cyan "Enter PostgreSQL password for $POSTGRES_USER:"
read -s POSTGRES_PASSWORD

# Update system packages
print_color yellow "Updating system packages..."
sudo apt update -y
sudo apt upgrade -y

# Install Apache2 (Web Server)
print_color green "Installing Apache2 Web Server..."
sudo apt install apache2 -y

# Install MySQL Server
print_color green "Installing MySQL Server..."
sudo apt install mysql-server -y

# Set root password for MySQL if specified
if [[ -n "$MYSQL_ROOT_PASSWORD" ]]; then
    print_color yellow "Setting MySQL root password to $MYSQL_ROOT_PASSWORD..."
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';"
fi

# Secure MySQL installation (automated, uses root password)
print_color yellow "Securing MySQL installation..."
sudo mysql_secure_installation <<EOF

y
$MYSQL_ROOT_PASSWORD
y
y
y
y
EOF

# Add PHP repository (if not already added)
print_color yellow "Adding PHP repository..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y

# Install PHP and necessary extensions based on the user input
print_color green "Installing PHP $PHP_VERSION..."
sudo apt install php$PHP_VERSION php$PHP_VERSION-cli php$PHP_VERSION-mysql php$PHP_VERSION-curl php$PHP_VERSION-json php$PHP_VERSION-xml php$PHP_VERSION-mbstring php$PHP_VERSION-zip php$PHP_VERSION-xmlrpc -y

# Install phpMyAdmin
print_color green "Installing phpMyAdmin..."
sudo apt install phpmyadmin -y

# Install PostgreSQL
print_color green "Installing PostgreSQL..."
sudo apt install postgresql postgresql-contrib -y

# Set PostgreSQL password for admin user
print_color yellow "Setting PostgreSQL password for $POSTGRES_USER..."
sudo -u postgres psql -c "ALTER USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';"

# Install pgAdmin
print_color green "Installing pgAdmin..."
# Add the pgAdmin repository and key
sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/ubuntu $(lsb_release -c | awk "{print $2}") pgadmin4" > /etc/apt/sources.list.d/pgadmin4.list'
sudo apt update -y

# Install pgAdmin (both web and desktop modes)
sudo apt install pgadmin4 pgadmin4-web -y

# Setup pgAdmin web interface
print_color yellow "Setting up pgAdmin web interface..."
sudo /usr/pgadmin4/bin/setup-web.sh

# Enable Apache rewrite module
sudo a2enmod rewrite

# Set the selected PHP version as the default
print_color yellow "Setting PHP $PHP_VERSION as the default version..."
sudo update-alternatives --set php /usr/bin/php$PHP_VERSION
sudo update-alternatives --set phpize /usr/bin/phpize$PHP_VERSION
sudo update-alternatives --set php-config /usr/bin/php-config$PHP_VERSION

# Restart Apache to apply changes
sudo systemctl restart apache2

# Allow Apache through firewall
sudo ufw allow 'Apache Full'

# Create a custom MySQL user if specified
if [[ -n "$MYSQL_USER" && -n "$MYSQL_PASSWORD" ]]; then
    print_color yellow "Creating MySQL user: $MYSQL_USER with the specified password..."
    sudo mysql -e "CREATE USER '$MYSQL_USER'@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';"
    sudo mysql -e "GRANT ALL PRIVILEGES ON *.* TO '$MYSQL_USER'@'localhost' WITH GRANT OPTION;"
    sudo mysql -e "FLUSH PRIVILEGES;"
    print_color green "MySQL user $MYSQL_USER created with the password you provided."
fi

# Check installation status
print_color green "Installation completed!"
print_color cyan "You can access phpMyAdmin at: http://localhost/phpmyadmin"
print_color cyan "You can access pgAdmin at: http://localhost/pgadmin4"
print_color yellow "MySQL root user password set to: $MYSQL_ROOT_PASSWORD"
if [[ -n "$MYSQL_USER" ]]; then
    print_color yellow "MySQL user $MYSQL_USER created with the password you provided."
fi
print_color yellow "PostgreSQL admin user password set for: $POSTGRES_USER"

# Footer: ASCII Art for Closing
echo -e "\033[1;34m"
echo "############################################################"
echo "#                                                          #"
echo "#    Installation Complete!                               #"
echo "#    Your LAMP + PostgreSQL + pgAdmin stack is ready!     #"
echo "#    Script Created by Tejpalsinh                          #"
echo "#    Email: ranatejpalsinh21@gmail.com                     #"
echo "#                                                          #"
echo "############################################################"
echo -e "\033[0m"
