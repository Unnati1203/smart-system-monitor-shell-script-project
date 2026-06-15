#!/bin/bash

source ./config.sh

LOG_FILE="system_monitor.log"

log_message() {
    echo "$(date) : $1" >> $LOG_FILE
}

echo "===== Monitoring Started at $(date) =====" >> $LOG_FILE

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}')
MEM_USAGE=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

log_message "CPU: $CPU_USAGE% | Memory: $MEM_USAGE% | Disk: $DISK_USAGE%"

# CPU Check
if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
    log_message "High CPU Usage!"
    PID=$(ps -eo pid,%cpu --sort=-%cpu | awk 'NR==2 {print $1}')
    kill -9 $PID
    log_message "Killed process $PID"
fi

# Memory Check
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    log_message "High Memory Usage!"
    sync; echo 3 > /proc/sys/vm/drop_caches
    log_message "Cache Cleared"
fi

# Disk Check
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    log_message "Low Disk Space!"
    rm -rf /tmp/*
    log_message "Temporary files cleared"
fi

echo "===== Monitoring Completed =====" >> $LOG_FILE
