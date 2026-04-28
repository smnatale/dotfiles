#!/bin/sh

case "$SENDER" in
  "mouse.entered")
    sketchybar --set wifi popup.drawing=on
    ;;
  "mouse.exited")
    sketchybar --set wifi popup.drawing=off
    ;;
  *)
    if ifconfig en1 2>/dev/null | grep -q "inet "; then
      # Try to get SSID using system_profiler (more reliable)
      SSID=$(system_profiler SPAirPortDataType 2>/dev/null | awk '/Current Network Information:/ {getline; print $0; exit}' | sed 's/://g' | xargs)
      if [ -n "$SSID" ]; then
        ICON="󰤨"
        LABEL="wifi"
      else
        ICON="󰤨"
        LABEL="wifi"
      fi
    elif ifconfig en0 2>/dev/null | grep -q "inet "; then
      ICON="󰈀"
      LABEL=""
    else
      ICON="󰤭"
      LABEL="off"
    fi
    sketchybar --set "$NAME" icon="$ICON" label="$LABEL"
    ;;
esac
