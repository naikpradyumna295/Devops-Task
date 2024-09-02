#!/bin/bash

# Execute all monitoring commands in sequence
./task1_monitor.sh --cpu       # Display top 10 applications by CPU and memory usage
./task1_monitor.sh --memory    # Display memory usage
./task1_monitor.sh --network   # Display network statistics
./task1_monitor.sh --disk      # Display disk usage by mounted partitions
./task1_monitor.sh --load      # Display system load
./task1_monitor.sh --processes # Display number of active processes
./task1_monitor.sh --services  # Monitor essential services

