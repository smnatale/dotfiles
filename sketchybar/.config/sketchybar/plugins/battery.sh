#!/bin/sh

# Check if battery exists - pmset returns different output on Macs vs PCs
BATTERY_INFO="$(pmset -g batt 2>/dev/null)"
PERCENTAGE="$(echo "$BATTERY_INFO" | grep -Eo "\d+%" | cut -d% -f1)"

# If no percentage found, there's no battery
if [ -z "$PERCENTAGE" ]; then
  sketchybar --set "$NAME" icon="" label=""
  exit 0
fi

CHARGING="$(echo "$BATTERY_INFO" | grep 'AC Power')"

case "${PERCENTAGE}" in
  9[0-9]|100) ICON="󰁹"
  ;;
  [6-8][0-9]) ICON="󰂁"
  ;;
  [3-5][0-9]) ICON="󰂂"
  ;;
  [1-2][0-9]) ICON="󰂃"
  ;;
  *) ICON="󰂎"
esac

if [[ "$CHARGING" != "" ]]; then
  ICON="󰚥"
fi

# The item invoking this script (name $NAME) will get its icon and label
# updated with the current battery status
sketchybar --set "$NAME" icon="$ICON" label="${PERCENTAGE}%"
