#!/bin/sh

case "$SENDER" in
  "mouse.entered")
    sketchybar --set disk popup.drawing=on
    ;;
  "mouse.exited")
    sketchybar --set disk popup.drawing=off
    ;;
  *)
    FREE=$(df -h / | tail -1 | awk '{print $4}')
    FREE=$(echo "$FREE" | sed 's/Gi$/G/;s/Mi$/M/;s/Ki$/K/')
    if echo "$FREE" | grep -q 'G$'; then
      FREE="${FREE}B"
    fi
    ICON="󰆼"
    sketchybar --set "$NAME" icon="$ICON" label="$FREE"
    ;;
esac