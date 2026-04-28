#!/bin/sh

case "$SENDER" in
  "mouse.entered")
    sketchybar --set cpu popup.drawing=on
    ;;
  "mouse.exited")
    sketchybar --set cpu popup.drawing=off
    ;;
  *)
    LOAD=$(ps -A -o %cpu | awk '{s+=$1} END {print s/4}' | cut -d. -f1)
    [ -z "$LOAD" ] && LOAD=0
    sketchybar --set "$NAME" icon="󰆼" label="${LOAD}%"
    ;;
esac