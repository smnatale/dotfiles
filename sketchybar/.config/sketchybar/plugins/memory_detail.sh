#!/bin/sh

# Get memory details
TOTAL=$(sysctl -n hw.memsize)
TOTAL_GB=$((TOTAL / 1024 / 1024 / 1024))

WIRED=$(vm_stat | grep "Pages wired:" | awk '{print $4}' | tr -d '.')
ACTIVE=$(vm_stat | grep "Pages active:" | awk '{print $3}' | tr -d '.')
INACTIVE=$(vm_stat | grep "Pages inactive:" | awk '{print $3}' | tr -d '.')
FREE=$(vm_stat | grep "Pages free:" | awk '{print $3}' | tr -d '.')

PAGES_TO_GB=4096

WIRED_GB=$((WIRED * PAGES_TO_GB / 1024 / 1024 / 1024))
ACTIVE_GB=$((ACTIVE * PAGES_TO_GB / 1024 / 1024 / 1024))
INACTIVE_GB=$((INACTIVE * PAGES_TO_GB / 1024 / 1024 / 1024))
FREE_GB=$((FREE * PAGES_TO_GB / 1024 / 1024 / 1024))

sketchybar --set memory.detail label="Total: ${TOTAL_GB} GB"
sketchybar --set memory.detail2 label="Wired: ${WIRED_GB} GB"
sketchybar --set memory.detail3 label="Active: ${ACTIVE_GB} GB"
sketchybar --set memory.detail4 label="Free: ${FREE_GB} GB"