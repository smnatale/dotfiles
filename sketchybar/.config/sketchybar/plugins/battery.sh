#!/bin/bash

# Battery plugin - shows battery icon + percentage
# Silently hides itself on devices without a battery

source "$CONFIG_DIR/palette.sh"

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
    COLOR="$ROSE_PINE_FOAM"
    BG="$ROSE_PINE_TRANSPARENT"
else
    if [ "$PERCENT" -le 10 ]; then ICON="󰂎"; COLOR="$ROSE_PINE_LOVE"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 20 ]; then ICON="󰁺"; COLOR="$ROSE_PINE_GOLD"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 30 ]; then ICON="󰁻"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 40 ]; then ICON="󰁼"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 50 ]; then ICON="󰁽"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 60 ]; then ICON="󰁾"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 70 ]; then ICON="󰁿"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 80 ]; then ICON="󰂀"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    elif [ "$PERCENT" -le 90 ]; then ICON="󰂁"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    else ICON="󰂂"; COLOR="$ROSE_PINE_TEXT"; BG="$ROSE_PINE_TRANSPARENT"
    fi
fi

sketchybar --set "$NAME" \
    drawing=on \
    icon="$ICON" \
    label="${PERCENT}%" \
    icon.color="$COLOR" \
    label.color="$ROSE_PINE_MUTED" \
    background.color="$BG"
