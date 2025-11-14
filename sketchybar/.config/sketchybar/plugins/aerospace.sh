#!/usr/bin/env bash

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=off label.color=0xffe0def4
else
    sketchybar --set $NAME background.drawing=off label.color=0xff6e6a86
fi
