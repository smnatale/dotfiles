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
      SSID=$(networksetup -getairportnetwork en1 2>/dev/null | grep -v "not associated" | cut -d: -f2 | xargs)
      if [ -n "$SSID" ]; then
        ICON="󰤨"
        LABEL=""
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