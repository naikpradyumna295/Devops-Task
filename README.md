
## Introduction

These scripts are invaluable for system administrators responsible for monitoring and securing Linux environments. They help track system performance metrics and automate security audits and server hardening processes.

## Task-1: Monitoring System Resources Script

The Monitoring System Resources Script is a comprehensive tool for tracking and displaying various system performance metrics on a Linux-based proxy server. It provides real-time monitoring and presents key performance indicators in a dashboard format.

### Features

- **Top 10 Applications by CPU Usage**: Displays the processes consuming the most CPU.
- **Top 10 Applications by Memory Usage**: Shows the processes using the most memory.
- **Network Monitoring**: Provides data on concurrent connections and packet drops.
- **Disk Usage by Mounted Partitions**: Shows the disk usage statistics of all mounted partitions.
- **System Load**: Displays the system load average.
- **Memory Usage**: Reports the current memory usage.
- **Process Monitoring**: Lists all active processes.
- **Service Monitoring**: Checks the status of critical services (ssh, nginx, iptables).

### Prerequisites

- Ubuntu

To install the required tools, run the following commands:
- `sudo apt-get update`
- `sudo apt-get install ifstat sysstat -y`

### Script Content

The script monitors various system resources and logs the results to a file. It includes functions to display CPU and memory usage, network statistics, disk usage, system load, memory usage, active processes, and service status.

### Usage

1. Save the script as `monitor_resources.sh`.
2. Make it executable: `chmod +x monitor_resources.sh`
3. Run the script: `./monitor_resources.sh`

## Task-2: Security Audit and Server Hardening Script

The Security Audit and Server Hardening Script automates the process of performing security audits and applying server hardening measures on Linux servers. This script helps ensure that your server environment is secure by combining multiple checks and actions.

### Features

- **User and Group Audits**: Lists users and groups, checks for root users, and identifies users with weak passwords.
- **File and Directory Permissions**: Scans for world-writable files, incorrect permissions on .ssh directories, and files with SUID/SGID bits set.
- **Service Audits**: Lists running services and checks for unauthorized services.
- **Firewall and Network Security**: Verifies firewall status, checks open ports, and reports insecure network configurations.
- **IP and Network Configuration Checks**: Differentiates between public and private IP addresses.
- **Security Updates and Patching**: Checks for available security updates using package managers.
- **Log Monitoring**: Searches logs for suspicious entries.
- **Server Hardening Steps**: Secures SSH, disables IPv6 if not needed, secures the bootloader, and configures automatic updates.
- **Custom Security Checks**: Placeholder for adding organization-specific security checks.
- **Reporting and Alerting**: Generates and saves a report of the audit.

### Prerequisites

- Ubuntu or other Linux distributions with compatible package managers (apt-get, yum).

### Script Content

The script performs a thorough security audit and applies basic hardening measures. It includes steps for user and group audits, file and directory permissions checks, service audits, firewall and network security checks, IP and network configuration checks, security updates, log monitoring, and server hardening.

### Usage

1. Save the script as `security_audit.sh`.
2. Make it executable: `chmod +x security_audit.sh`
3. Run the script with sudo privileges: `sudo ./security_audit.sh`

