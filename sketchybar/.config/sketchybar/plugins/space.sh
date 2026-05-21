#!/bin/sh

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" \
    icon.color=0xff0c0c0c \
    background.drawing=on \
    background.color=0xffc4a7e7 \
    background.corner_radius=8 \
    background.height=26
else
  sketchybar --set "$NAME" \
    icon.color=0xff908caa \
    background.drawing=off
fi
