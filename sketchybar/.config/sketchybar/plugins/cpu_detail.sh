#!/bin/sh

# Get detailed CPU info
CPU=$(ps -A -o %cpu | awk '{s+=$1} END {print s/4}' | cut -d. -f1)
[ -z "$CPU" ] && CPU=0

MODEL=$(sysctl -n machdep.cpu.brand_string 2>/dev/null | cut -d' ' -f1-4)
[ -z "$MODEL" ] && MODEL="CPU"

CORES=$(sysctl -n hw.ncpu)

LOAD=$(uptime | awk -F'load averages:' '{print $2}' | awk '{print $1 ", " $2 ", " $3}')

sketchybar --set cpu.detail label="Model: ${MODEL}"
sketchybar --set cpu.detail2 label="Cores: ${CORES}"
sketchybar --set cpu.detail3 label="Load: ${LOAD}"