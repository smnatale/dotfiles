#!/bin/bash

# Aerospace workspace updater - polls fast and updates all space items at once
# This is more efficient than each space item polling individually

FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

for sid in 1 2 3 4 5; do
  if [ "$FOCUSED" = "$sid" ]; then
    sketchybar --set space.$sid \
      label.color=0xff191724 \
      background.color=0xffc4a7e7
  else
    sketchybar --set space.$sid \
      label.color=0xff6e6a86 \
      background.color=0xff26233a
  fi
done
