#!/bin/bash

# Function to display top 10 applications by CPU and memory usage
display_cpu_memory() {
    echo "Top 10 Applications by CPU and Memory Usage:"
    ps -eo pid,user,%cpu,%mem,command --sort=-%cpu | head -n 11
}

# Function to display memory usage
display_memory_usage() {
    echo "Memory Usage:"
    free -h
}

# Function to display network statistics
display_network_stats() {
    echo "Network Statistics:"
    echo "Concurrent Connections: $(netstat -an | grep ESTABLISHED | wc -l)"
    echo "Packet Drops:"
    ifstat -t 1 1 | tail -n 1 | awk '{print "Packets In: "$6" Packets Out: "$8}'
}

# Function to display disk usage by mounted partitions
display_disk_usage() {
    echo "Disk Usage by Mounted Partitions:"
    df -h | grep '^/dev/'
}

# Function to display system load
display_system_load() {
    echo "System Load:"
    uptime
    mpstat -P ALL 1 1
}

# Function to display active processes
display_active_processes() {
    echo "Active Processes: $(ps aux | wc -l)"
}

# Function to monitor essential services
monitor_services() {
    echo "Service Monitoring:"
    for service in sshd nginx iptables; do
        status=$(systemctl is-active $service)
        echo "$service: $status"
    done
}

# Handle command-line arguments to display specific dashboard sections
case "$1" in
    --cpu)
        display_cpu_memory
        ;;
    --memory)
        display_memory_usage
        ;;
    --network)
        display_network_stats
        ;;
    --disk)
        display_disk_usage
        ;;
    --load)
        display_system_load
        ;;
    --processes)
        display_active_processes
        ;;
    --services)
        monitor_services
        ;;
    *)
        echo "Usage: $0 {--cpu|--memory|--network|--disk|--load|--processes|--services}"
        ;;
esac

