#!/bin/sh

# Check if this is a mouse event
if [ "$1" = "mouse.entered" ]; then
  sketchybar --set "$NAME" background.color=0x990c0c0c
elif [ "$1" = "mouse.exited" ]; then
  sketchybar --set "$NAME" background.color=0x660c0c0c
else
  sketchybar --set "$NAME" label="$(date '+%a %b %d %H:%M')"
fi