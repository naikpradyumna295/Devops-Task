# Monitoring System Resources Script

This Bash script is designed to monitor various system resources on a proxy server and present them in a dashboard format. Users can call specific parts of the dashboard using command-line switches.

## Features

- Top 10 Applications by CPU and Memory Usage
- Network Monitoring (Concurrent Connections and Packet Drops)
- Disk Usage by Mounted Partitions
- System Load
- Memory Usage
- Process Monitoring (Active Processes)
- Service Monitoring (ssh, nginx, iptables)

## Prerequisites

- **Ubuntu**
- Install required tools:
  ```bash
  sudo apt-get update
  sudo apt-get install ifstat sysstat -y
