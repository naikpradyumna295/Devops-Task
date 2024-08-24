#!/bin/bash

# Execute all monitoring commands in sequence
./monitor.sh --cpu       # Display top 10 applications by CPU and memory usage
./monitor.sh --memory    # Display memory usage
./monitor.sh --network   # Display network statistics
./monitor.sh --disk      # Display disk usage by mounted partitions
./monitor.sh --load      # Display system load
./monitor.sh --processes # Display number of active processes
./monitor.sh --services  # Monitor essential services

