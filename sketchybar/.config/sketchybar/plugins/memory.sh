#!/bin/sh

case "$SENDER" in
  "mouse.entered")
    sketchybar --set memory popup.drawing=on
    ;;
  "mouse.exited")
    sketchybar --set memory popup.drawing=off
    ;;
  *)
    TOTAL=$(sysctl -n hw.memsize 2>/dev/null)
    TOTAL_GB=$((TOTAL / 1024 / 1024 / 1024))
    WIRED=$(vm_stat | grep "Pages wired:" | awk '{print $4}' | tr -d '.')
    ACTIVE=$(vm_stat | grep "Pages active:" | awk '{print $3}' | tr -d '.')
    USED=$(( (WIRED + ACTIVE) * 4096 / 1024 / 1024 / 1024 ))
    ICON="󰍜"
    sketchybar --set "$NAME" icon="$ICON" label="${USED}GB / ${TOTAL_GB}GB"
    ;;
esac