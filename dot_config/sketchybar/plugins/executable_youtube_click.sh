#!/bin/bash

case "$BUTTON" in
  left) "$CONFIG_DIR/plugins/youtube.sh" ;;
  right) sketchybar --set "$NAME" label.drawing=toggle ;;
esac
