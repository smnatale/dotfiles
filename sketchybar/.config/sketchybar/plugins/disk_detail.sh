#!/bin/sh

# Get disk info - use df on /System/Volumes/Data mount
if [ -d "/System/Volumes/Data" ]; then
    DISK_INFO=$(df -h /System/Volumes/Data | tail -1)
else
    DISK_INFO=$(df -h / | tail -1)
fi

TOTAL=$(echo "$DISK_INFO" | awk '{print $2}')
USED=$(echo "$DISK_INFO" | awk '{print $3}')
FREE=$(echo "$DISK_INFO" | awk '{print $4}')
USE_PCT=$(echo "$DISK_INFO" | awk '{print $5}')

sketchybar --set disk.detail label="Total: ${TOTAL}"
sketchybar --set disk.detail2 label="Used: ${USED}"
sketchybar --set disk.detail3 label="Free: ${FREE} (${USE_PCT})"