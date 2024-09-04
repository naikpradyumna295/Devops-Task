#!/bin/bash


# Function to check if running as root
check_root() {
    if [ "$(id -u)" != "0" ]; then
        echo "This script must be run as root" 1>&2
        exit 1
    fi
}

# Function to log messages
log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Main function
main() {
    check_root

    log_message "Starting server hardening process..."

    # Update and upgrade system
    log_message "Updating and upgrading system..."
    apt update && apt upgrade -y

    # Install necessary packages
    log_message "Installing necessary packages..."
    apt install -y ufw fail2ban unattended-upgrades

    # Configure firewall
    log_message "Configuring firewall..."
    ufw default deny incoming
    ufw default allow outgoing
    ufw allow ssh
    ufw allow http
    ufw allow https
    ufw --force enable

    # Configure fail2ban
    log_message "Configuring fail2ban..."
    systemctl enable fail2ban
    systemctl start fail2ban

    # Secure SSH
    log_message "Securing SSH..."
    sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
    sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    systemctl restart sshd

    # Configure automatic updates
    log_message "Configuring automatic updates..."
    echo 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Download-Upgradeable-Packages "1";
APT::Periodic::AutocleanInterval "7";
APT::Periodic::Unattended-Upgrade "1";' > /etc/apt/apt.conf.d/20auto-upgrades

    # Disable unnecessary services
    log_message "Disabling unnecessary services..."
    systemctl disable avahi-daemon
    systemctl disable cups
    systemctl disable rpcbind

    # Set secure file permissions
    log_message "Setting secure file permissions..."
    chmod 700 /root
    chmod 700 /home/*
    chmod 644 /etc/passwd
    chmod 644 /etc/group
    chmod 600 /etc/shadow
    chmod 600 /etc/gshadow

    # Configure system logging
    log_message "Configuring system logging..."
    sed -i 's/^#FileCreateMode/FileCreateMode/' /etc/rsyslog.conf
    sed -i 's/^#FileCreateMode 0640/FileCreateMode 0640/' /etc/rsyslog.conf
    systemctl restart rsyslog

    # Enable process accounting
    log_message "Enabling process accounting..."
    apt install -y acct
    /etc/init.d/acct start

    # Secure GRUB bootloader
    log_message "Securing GRUB bootloader..."
    grub-mkpasswd-pbkdf2 | tee /tmp/grub_password.txt
    GRUB_PASSWORD=$(tail -n 1 /tmp/grub_password.txt | awk '{print $NF}')
    echo "set superusers=\"root\"
password_pbkdf2 root $GRUB_PASSWORD" > /etc/grub.d/40_custom
    update-grub
    rm /tmp/grub_password.txt

    # Disable IPv6 if not needed
    log_message "Disabling IPv6..."
    echo "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p

    # Final system update
    log_message "Performing final system update..."
    apt update && apt upgrade -y

    log_message "Server hardening completed. Please review the changes and reboot the system."
}

# Run the main function
main
