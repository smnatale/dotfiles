#!/usr/bin/env bash

# The item name is set by sketchybar (e.g., space.CA4AEA35-8E40-427E-82BF-3680E82AB383)
WORKSPACE_UUID="${NAME#space.}"

# Get the currently focused workspace ID (UUID)
FOCUSED=$(/Applications/OmniWM.app/Contents/MacOS/omniwmctl query active-workspace --format json | /usr/bin/jq -r '.result.payload.workspace.id' 2>/dev/null)

if [ "$WORKSPACE_UUID" = "$FOCUSED" ]; then
    sketchybar --set $NAME icon.color=0xff0c0c0c background.color=0xffc4a7e7
else
    sketchybar --set $NAME icon.color=0xff908caa background.color=0x660c0c0c
fi