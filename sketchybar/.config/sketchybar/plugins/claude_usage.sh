#!/bin/bash

# Claude Code Usage plugin for sketchybar
# Displays session (5h) and weekly (7d) usage percentages

PLUGIN_DIR="$(dirname "$0")"
CACHE_FILE="/tmp/sketchybar_claude_usage.json"
CACHE_MAX_AGE=300 # 5 minutes

# Use cache if fresh enough
if [ -f "$CACHE_FILE" ]; then
    cache_age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
    if [ "$cache_age" -lt "$CACHE_MAX_AGE" ]; then
        SESSION=$(jq -r '.session // "?"' "$CACHE_FILE")
        WEEKLY=$(jq -r '.weekly // "?"' "$CACHE_FILE")
    fi
fi

# Fetch fresh data if no cache hit
if [ -z "$SESSION" ]; then
    RESPONSE=$("$PLUGIN_DIR/claude_fetch" 2>/dev/null)

    if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
        sketchybar --set "$NAME" label="err"
        exit 1
    fi

    SESSION=$(echo "$RESPONSE" | jq -r '.session // 0')
    WEEKLY=$(echo "$RESPONSE" | jq -r '.weekly // 0')
    echo "$RESPONSE" > "$CACHE_FILE"
fi

# Color based on higher of session/weekly
MAX=$SESSION
[ "$WEEKLY" -gt "$MAX" ] 2>/dev/null && MAX=$WEEKLY

if [ "$MAX" -ge 90 ] 2>/dev/null; then
    COLOR="0xffeb6f92"  # Love/red
elif [ "$MAX" -ge 70 ] 2>/dev/null; then
    COLOR="0xfff6c177"  # Gold/orange
else
    COLOR="0xffe0def4"  # Default text
fi

sketchybar --set "$NAME" label="${SESSION}%/${WEEKLY}%" label.color="$COLOR"
