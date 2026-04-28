#!/usr/bin/env bash

# The item name is set by sketchybar (e.g., space.CA4AEA35-8E40-427E-82BF-3680E82AB383)
WORKSPACE_UUID="${NAME#space.}"

# Get the currently focused workspace ID (UUID)
FOCUSED=$(/Applications/OmniWM.app/Contents/MacOS/omniwmctl query active-workspace --format json | /usr/bin/jq -r '.result.payload.workspace.id' 2>/dev/null)

if [ "$WORKSPACE_UUID" = "$FOCUSED" ]; then
    sketchybar --set $NAME label.color=0xffe0def4
else
    sketchybar --set $NAME label.color=0xff6e6a86
fi