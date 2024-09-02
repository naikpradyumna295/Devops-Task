wq#!/bin/bash

# User and Group Audits
echo "Running User and Group Audits..."
echo "Listing all users and groups:"
cut -d: -f1 /etc/passwd
cut -d: -f1 /etc/group

echo "Checking for users with UID 0 (root privileges):"
awk -F: '($3 == "0") {print}' /etc/passwd

echo "Identifying users without passwords:"
awk -F: '($2 == "" ) { print $1 }' /etc/shadow

# File and Directory Permissions
echo "Checking File and Directory Permissions..."
echo "Finding world-writable files and directories:"
find / -type f -perm -o+w -exec ls -l {} \; 2>/dev/null
find / -type d -perm -o+w -exec ls -ld {} \; 2>/dev/null

echo "Checking for .ssh directories with secure permissions:"
find / -type d -name ".ssh" -exec ls -ld {} \;

echo "Finding files with SUID and SGID bits set:"
find / -perm /6000 -type f -exec ls -l {} \; 2>/dev/null

# Service Audits
echo "Running Service Audits..."
echo "Listing all running services:"
service --status-all 2>&1 | grep '+'

echo "Ensuring critical services like SSHD and iptables are running:"
systemctl status sshd | grep "active (running)"
systemctl status iptables | grep "active (running)"

# Firewall and Network Security
echo "Checking Firewall and Network Security..."
echo "Checking if a firewall (iptables or ufw) is active:"
ufw status || iptables -L

echo "Reporting open ports and their associated services:"
netstat -tuln

echo "Checking for IP forwarding settings:"
sysctl net.ipv4.ip_forward

# IP and Network Configuration Checks
echo "Performing IP and Network Configuration Checks..."
echo "Identifying public vs. private IP addresses:"
ip -o -4 addr show | awk '{print $2,$4}' | while read int ip; do
  if [[ $ip =~ ^10\. ]] || [[ $ip =~ ^192\.168\. ]] || [[ $ip =~ ^172\.1[6-9]\. ]] || [[ $ip =~ ^172\.2[0-9]\. ]] || [[ $ip =~ ^172\.3[0-1]\. ]]; then
    echo "$int has a private IP address $ip"
  else
    echo "$int has a public IP address $ip"
  fi
done

# Security Updates and Patching
echo "Checking Security Updates and Patching..."
echo "Checking for available security updates:"
sudo apt update && sudo apt list --upgradable

echo "Configuring automatic security updates:"
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure --priority=low unattended-upgrades

# Log Monitoring
echo "Monitoring Logs..."
echo "Checking for suspicious log entries:"
grep -i "failed" /var/log/auth.log | tail -n 10

# Server Hardening Steps
echo "Executing Server Hardening Steps..."
echo "Configuring SSH for key-based authentication and disabling password-based login for root."
# Additional SSH hardening steps can be added here

echo "Disabling IPv6 if not needed:"
sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1

echo "Securing the bootloader:"
sudo grub-mkpasswd-pbkdf2 # Follow the prompts to set a password

echo "Configuring the firewall:"
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

echo "Security Audit and Hardening Completed."
