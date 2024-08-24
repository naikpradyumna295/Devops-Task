#!/bin/bash

# Script: security_audit.sh
# Description: Automates security audits and server hardening tasks on Linux servers.
# Author: [Your Name]
# Date: $(date)

# Define log file
LOG_DIR=~/security_audit/logs
LOG_FILE="$LOG_DIR/security_audit_$(date +%F).log"
mkdir -p $LOG_DIR

# Function to log messages
log_message() {
    echo "$1" | tee -a $LOG_FILE
}

log_message "Starting security audit and server hardening process - $(date)"

# 1. User and Group Audits
log_message "1. User and Group Audits"

log_message "Listing all users..."
awk -F':' '{ print $1 }' /etc/passwd | tee -a $LOG_FILE

log_message "Listing all groups..."
awk -F':' '{ print $1 }' /etc/group | tee -a $LOG_FILE

log_message "Checking for users with UID 0 (root privileges)..."
awk -F: '($3 == "0") {print $1}' /etc/passwd | tee -a $LOG_FILE

log_message "Identifying users without passwords or with weak passwords..."
awk -F: '($2 == "" || $2 == "*") {print $1 " has no password set or uses weak password!"}' /etc/shadow | tee -a $LOG_FILE

# 2. File and Directory Permissions
log_message "2. File and Directory Permissions"

log_message "Scanning for files with world-writable permissions..."
find / -type f -perm -0002 -exec ls -l {} \; 2>/dev/null | tee -a $LOG_FILE

log_message "Checking for .ssh directories with incorrect permissions..."
find / -type d -name ".ssh" -exec ls -ld {} \; 2>/dev/null | grep -v "drwx------" | tee -a $LOG_FILE

log_message "Reporting files with SUID or SGID bits set..."
find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} \; 2>/dev/null | tee -a $LOG_FILE

# 3. Service Audits
log_message "3. Service Audits"

log_message "Listing all running services..."
systemctl list-units --type=service --state=running | tee -a $LOG_FILE

log_message "Checking for unnecessary or unauthorized services..."
UNAUTHORIZED_SERVICES=("telnet" "ftp" "rsh" "rlogin")
for service in "${UNAUTHORIZED_SERVICES[@]}"; do
    systemctl is-active --quiet $service && log_message "$service is running and should be disabled!"
done

# 4. Firewall and Network Security
log_message "4. Firewall and Network Security"

log_message "Checking if firewalls are active and configured..."
if command -v ufw &>/dev/null; then
    ufw status | tee -a $LOG_FILE
elif command -v iptables &>/dev/null; then
    iptables -L | tee -a $LOG_FILE
else
    log_message "No firewall is installed!"
fi

log_message "Checking open ports and their associated services..."
netstat -tuln | grep LISTEN | tee -a $LOG_FILE

log_message "Checking for IP forwarding and other insecure network configurations..."
sysctl net.ipv4.ip_forward | grep "= 1" && log_message "IP forwarding is enabled and should be disabled!"

# 5. IP and Network Configuration Checks
log_message "5. IP and Network Configuration Checks"

log_message "Identifying public vs. private IP addresses..."
IP_ADDRESSES=$(hostname -I)
for ip in $IP_ADDRESSES; do
    if [[ $ip == 10.* || $ip == 192.168.* || $ip == 172.16.* || $ip == 172.31.* ]]; then
        log_message "$ip is a private IP address."
    else
        log_message "$ip is a public IP address."
    fi
done

# 6. Security Updates and Patching
log_message "6. Security Updates and Patching"

log_message "Checking for available security updates..."
if command -v apt-get &>/dev/null; then
    apt-get update && apt-get --just-print upgrade | grep "Inst" | tee -a $LOG_FILE
elif command -v yum &>/dev/null; then
    yum check-update --security | tee -a $LOG_FILE
fi

# 7. Log Monitoring
log_message "7. Log Monitoring"

log_message "Checking for suspicious log entries..."
grep "Failed password" /var/log/auth.log | tail -n 10 | tee -a $LOG_FILE

# 8. Server Hardening Steps
log_message "8. Server Hardening Steps"

log_message "Securing SSH Configuration..."
sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
systemctl restart sshd

log_message "Disabling IPv6 if not required..."
sysctl -w net.ipv6.conf.all.disable_ipv6=1 | tee -a $LOG_FILE
sysctl -w net.ipv6.conf.default.disable_ipv6=1 | tee -a $LOG_FILE

log_message "Securing the bootloader..."
echo "password_pbkdf2 grub2 $6$randomsalt$...your_hashed_password..." >> /etc/grub.d/01_users
grub-mkconfig -o /boot/grub/grub.cfg

log_message "Configuring automatic updates..."
if command -v apt-get &>/dev/null; then
    apt-get install unattended-upgrades
    dpkg-reconfigure --priority=low unattended-upgrades
elif command -v yum &>/dev/null; then
    yum install yum-cron -y
    systemctl enable yum-cron && systemctl start yum-cron
fi

# 9. Custom Security Checks
log_message "9. Custom Security Checks"

# Placeholder for custom checks - adjust as necessary
log_message "Custom checks can be added here based on organizational policies."

# 10. Reporting and Alerting
log_message "10. Reporting and Alerting"

log_message "Security audit and server hardening completed. Report saved to $LOG_FILE."

# End of Script
log_message "End of security audit - $(date)"
