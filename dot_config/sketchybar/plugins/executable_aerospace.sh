#!/bin/bash

# Aerospace workspace updater - triggered by sketchybar's custom event
# AeroSpace passes FOCUSED_WORKSPACE via the event trigger.
# Falls back to querying aerospace directly when the variable is missing
# (e.g. during sketchybar --update on startup).

source "$CONFIG_DIR/palette.sh"

SID="$1"

# Resolve aerospace binary path (sketchybar runs with minimal PATH)
if [ -x "/opt/homebrew/bin/aerospace" ]; then
  AEROSPACE="/opt/homebrew/bin/aerospace"
elif [ -x "/usr/local/bin/aerospace" ]; then
  AEROSPACE="/usr/local/bin/aerospace"
elif command -v aerospace >/dev/null 2>&1; then
  AEROSPACE="$(command -v aerospace)"
else
  exit 1
fi

FOCUSED="${FOCUSED_WORKSPACE:-$("$AEROSPACE" list-workspaces --focused 2>/dev/null)}"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" \
    label.color="$ROSE_PINE_FOAM" \
    background.color="$ROSE_PINE_TRANSPARENT"
else
  sketchybar --set "$NAME" \
    label.color="$ROSE_PINE_MUTED" \
    background.color="$ROSE_PINE_TRANSPARENT"
fi
