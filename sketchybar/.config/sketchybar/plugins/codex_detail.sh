#!/bin/sh

CACHE_FILE="/tmp/sketchybar_codex_usage.json"

format_duration() {
  total="$1"
  [ -z "$total" ] && return 0

  days=$(( total / 86400 ))
  hours=$(( (total % 86400) / 3600 ))
  mins=$(( (total % 3600) / 60 ))

  if [ "$days" -gt 0 ]; then
    printf '%dd%dh%dm' "$days" "$hours" "$mins"
  elif [ "$hours" -gt 0 ]; then
    printf '%dh%dm' "$hours" "$mins"
  else
    printf '%dm' "$mins"
  fi
}

if [ ! -f "$CACHE_FILE" ]; then
  sketchybar --set codex_usage.detail label="Used: codex auth" \
             --set codex_usage.weekly label="Weekly: -" \
             --set codex_usage.reset label="Reset: -"
  exit 0
fi

EMAIL=$(jq -r '.email // ""' "$CACHE_FILE")
USED=$(jq -r '.rate_limit.primary_window.used_percent // 0' "$CACHE_FILE")
WEEKLY=$(jq -r '.rate_limit.secondary_window.used_percent // 0' "$CACHE_FILE")
RESET_AFTER=$(jq -r '.rate_limit.primary_window.reset_after_seconds // 0' "$CACHE_FILE")

COUNTDOWN="$(format_duration "$RESET_AFTER")"

if [ -n "$EMAIL" ]; then
  DETAIL="Account: ${EMAIL}"
else
  DETAIL="Used: ${USED}%"
fi

sketchybar --set codex_usage.detail label="$DETAIL" \
           --set codex_usage.weekly label="Weekly: ${WEEKLY}%" \
           --set codex_usage.reset label="Reset: ${COUNTDOWN}"
