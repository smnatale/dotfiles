#!/bin/sh

# Get Claude usage info
CACHE_FILE="/tmp/sketchybar_claude_usage.json"

if [ -f "$CACHE_FILE" ]; then
  SESSION=$(jq -r '.session // "0"' "$CACHE_FILE")
  WEEKLY=$(jq -r '.weekly // "0"' "$CACHE_FILE")
  
  sketchybar --set claude_usage.detail label="Session: ${SESSION}%" \
             --set claude_usage.weekly label="Weekly: ${WEEKLY}%"
else
  sketchybar --set claude_usage.detail label="Session: -" \
             --set claude_usage.weekly label="Weekly: -"
fi