#!/bin/bash

# Space plugin - highlights the active aerospace workspace
# Called with $NAME set to e.g. "space.1", we extract the workspace ID

SID="${NAME#space.}"
FOCUSED=$(aerospace list-workspaces --focused 2>/dev/null)

if [ "$FOCUSED" = "$SID" ]; then
    sketchybar --set "$NAME" \
        label.color=0xffe0def4 \
        background.color=0xe6191724
else
    sketchybar --set "$NAME" \
        label.color=0xff6e6a86 \
        background.color=0x00000000
fi
