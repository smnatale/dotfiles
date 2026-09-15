#!/bin/bash

source "$CONFIG_DIR/palette.sh"

SID="$1"
AEROSPACE="/opt/homebrew/bin/aerospace"

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
