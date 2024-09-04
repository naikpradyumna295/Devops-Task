#!/bin/bash

echo "Top 10 Applications by CPU and Memory Usage:"
ps aux --sort=-%cpu,-%mem | head -n 11

echo "Memory Usage:"
free -m

echo "Network Statistics:"
if command -v ss &> /dev/null; then
    echo "Concurrent Connections:"
    ss -s | grep "TCP:"
else
    echo "ss command not found. Install iproute2 package for network statistics."
fi

echo "Packet Drops:"
if command -v ifconfig &> /dev/null; then
    ifconfig | grep -i "RX packets" | awk '{print $6 " " $7 " " $8 " " $9 " " $10}'
elif command -v ip &> /dev/null; then
    ip -s link | grep -A 1 "RX:" | grep -v "RX:" | awk '{print $4 " drops"}'
else
    echo "Neither ifconfig nor ip command found. Install net-tools or iproute2 package."
fi

echo "Disk Usage by Mounted Partitions:"
df -h

echo "System Load:"
uptime

echo "CPU Utilization:"
if command -v mpstat &> /dev/null; then
    mpstat 1 1
else
    echo "mpstat command not found. Install sysstat package for CPU utilization."
fi

echo "Active Processes:" $(ps -e | wc -l)

echo "Service Monitoring:"
services=("sshd" "nginx" "iptables")
for service in "${services[@]}"; do
    if systemctl is-active --quiet $service; then
        echo "$service: active"
    elif systemctl is-enabled --quiet $service; then
        echo "$service: enabled but not active"
    else
        echo "$service: not installed or not enabled"
    fi
done
