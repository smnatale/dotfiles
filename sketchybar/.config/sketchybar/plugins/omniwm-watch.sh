#!/usr/bin/env bash

# Watch OmniWM workspace changes and trigger sketchybar updates

OMNIWMCTL="/Applications/OmniWM.app/Contents/MacOS/omniwmctl"
SKETCHYBAR="/opt/homebrew/bin/sketchybar"

# Keep subscription open and re-run when it dies
while true; do
    "$OMNIWMCTL" subscribe active-workspace --no-send-initial 2>/dev/null | while read -r line; do
        "$SKETCHYBAR" --trigger omniwm_workspace_change 2>/dev/null
    done
    sleep 1
done