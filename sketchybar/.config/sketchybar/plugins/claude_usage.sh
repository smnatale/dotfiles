#!/bin/bash

# Check for hover events
case "$SENDER" in
  "mouse.entered")
    sketchybar --set claude_usage popup.drawing=on
    exit 0
    ;;
  "mouse.exited")
    sketchybar --set claude_usage popup.drawing=off
    exit 0
    ;;
esac

# Claude Code Usage plugin for sketchybar
# Displays session (5h) and weekly (7d) usage percentages

PLUGIN_DIR="$(dirname "$0")"
CACHE_FILE="/tmp/sketchybar_claude_usage.json"
CACHE_MAX_AGE=60 # 1 minute

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
    RESPONSE=$("$PLUGIN_DIR/claude_fetch.lua" 2>/dev/null)

    if echo "$RESPONSE" | jq -e '.error' > /dev/null 2>&1; then
        sketchybar --set "$NAME" label="err"
        exit 1
    fi

    SESSION=$(echo "$RESPONSE" | jq -r '.session // 0')
    WEEKLY=$(echo "$RESPONSE" | jq -r '.weekly // 0')
    SESSION_RESET=$(echo "$RESPONSE" | jq -r '.session_reset // ""')
    WEEKLY_RESET=$(echo "$RESPONSE" | jq -r '.weekly_reset // ""')
    echo "$RESPONSE" > "$CACHE_FILE"
fi

# Read reset times from cache if not set
if [ -z "$SESSION_RESET" ] && [ -f "$CACHE_FILE" ]; then
    SESSION_RESET=$(jq -r '.session_reset // ""' "$CACHE_FILE")
    WEEKLY_RESET=$(jq -r '.weekly_reset // ""' "$CACHE_FILE")
fi

# Color based on higher of session/weekly
MAX=$SESSION
RESET_ISO="$SESSION_RESET"
if [ "$WEEKLY" -gt "$MAX" ] 2>/dev/null; then
    MAX=$WEEKLY
    RESET_ISO="$WEEKLY_RESET"
fi

if [ "$MAX" -ge 90 ] 2>/dev/null; then
    COLOR="0xffeb6f92"  # Love/red
elif [ "$MAX" -ge 70 ] 2>/dev/null; then
    COLOR="0xfff6c177"  # Gold/orange
else
    COLOR="0xffe0def4"  # Default text
fi

# Build label with reset countdown
LABEL="${SESSION}%/${WEEKLY}%"
if [ -n "$RESET_ISO" ]; then
    RESET_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$(echo "$RESET_ISO" | cut -c1-19)" "+%s" 2>/dev/null)
    NOW_EPOCH=$(date +%s)
    if [ -n "$RESET_EPOCH" ] && [ "$RESET_EPOCH" -gt "$NOW_EPOCH" ] 2>/dev/null; then
        DIFF=$(( RESET_EPOCH - NOW_EPOCH ))
        HOURS=$(( DIFF / 3600 ))
        MINS=$(( (DIFF % 3600) / 60 ))
        if [ "$HOURS" -gt 0 ]; then
            LABEL="${LABEL} ${HOURS}h${MINS}m"
        else
            LABEL="${LABEL} ${MINS}m"
        fi
    fi
fi

sketchybar --set "$NAME" label="$LABEL" label.color="$COLOR"
