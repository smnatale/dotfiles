#!/bin/bash

# Battery plugin - shows battery icon + percentage
# Silently hides itself on devices without a battery

BATT_INFO=$(pmset -g batt 2>/dev/null)
if [ -z "$BATT_INFO" ] || ! echo "$BATT_INFO" | grep -q "InternalBattery"; then
    sketchybar --set "$NAME" drawing=off
    exit 0
fi

PERCENT=$(echo "$BATT_INFO" | grep -o "[0-9]\+%" | head -1 | tr -d '%')

if echo "$BATT_INFO" | grep -q "Battery Power"; then
    CHARGING=0
elif echo "$BATT_INFO" | grep -q "AC Power"; then
    CHARGING=1
else
    CHARGING=0
fi

if [ "$CHARGING" -eq 1 ]; then
    ICON="󰂄"
    COLOR="0xff9ccfd8"
    BG="0x00000000"
else
    if [ "$PERCENT" -le 10 ]; then ICON="󰂎"; COLOR="0xffeb6f92"; BG="0x00000000"
    elif [ "$PERCENT" -le 20 ]; then ICON="󰁺"; COLOR="0xfff6c177"; BG="0x00000000"
    elif [ "$PERCENT" -le 30 ]; then ICON="󰁻"; COLOR="0xffe0def4"; BG="0x00000000"
    elif [ "$PERCENT" -le 40 ]; then ICON="󰁼"; COLOR="0xffe0def4"; BG="0x00000000"
    elif [ "$PERCENT" -le 50 ]; then ICON="󰁽"; COLOR="0xffe0def4"; BG="0x00000000"
    elif [ "$PERCENT" -le 60 ]; then ICON="󰁾"; COLOR="0xffe0def4"; BG="0x00000000"
    elif [ "$PERCENT" -le 70 ]; then ICON="󰁿"; COLOR="0xffe0def4"; BG="0x00000000"
    elif [ "$PERCENT" -le 80 ]; then ICON="󰂀"; COLOR="0xffe0def4"; BG="0x00000000"
    elif [ "$PERCENT" -le 90 ]; then ICON="󰂁"; COLOR="0xffe0def4"; BG="0x00000000"
    else ICON="󰂂"; COLOR="0xffe0def4"; BG="0x00000000"
    fi
fi

sketchybar --set "$NAME" \
    drawing=on \
    icon="$ICON" \
    label="${PERCENT}%" \
    icon.color="$COLOR" \
    label.color="$COLOR" \
    background.color="$BG"
