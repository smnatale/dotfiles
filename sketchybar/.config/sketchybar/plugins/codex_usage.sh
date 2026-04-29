#!/bin/sh

CACHE_FILE="/tmp/sketchybar_codex_usage.json"
CACHE_MAX_AGE=60
ENDPOINT="https://chatgpt.com/backend-api/wham/usage"
AUTH_FILE="$HOME/.codex/auth.json"

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

load_cached_response() {
  if [ -f "$CACHE_FILE" ]; then
    cache_age=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE") ))
    if [ "$cache_age" -lt "$CACHE_MAX_AGE" ]; then
      cat "$CACHE_FILE"
      return 0
    fi
  fi
  return 1
}

fetch_response() {
  if [ ! -f "$AUTH_FILE" ]; then
    return 1
  fi

  ACCESS_TOKEN=$(jq -r '.tokens.access_token // empty' "$AUTH_FILE" 2>/dev/null)
  if [ -z "$ACCESS_TOKEN" ]; then
    return 1
  fi

  curl -fsSL --max-time 10 "$ENDPOINT" \
    -H "Authorization: Bearer $ACCESS_TOKEN" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json"
}

RESPONSE=""
if ! RESPONSE="$(load_cached_response)"; then
  RESPONSE=""
fi

if [ -z "$RESPONSE" ]; then
  if RESPONSE="$(fetch_response 2>/dev/null)"; then
    FETCH_FAILED=0
  else
    FETCH_FAILED=1
  fi
else
  FETCH_FAILED=0
fi

if [ -z "$RESPONSE" ]; then
  if [ -f "$CACHE_FILE" ]; then
    RESPONSE="$(cat "$CACHE_FILE")"
  fi
fi

if [ -z "$RESPONSE" ]; then
  sketchybar --set "$NAME" label="codex auth" label.color="0xffeb6f92"
  exit 1
fi

if ! printf '%s' "$RESPONSE" | jq -e '.rate_limit.primary_window.used_percent' >/dev/null 2>&1; then
  sketchybar --set "$NAME" label="codex auth" label.color="0xffeb6f92"
  exit 1
fi

echo "$RESPONSE" > "$CACHE_FILE"

USED=$(printf '%s' "$RESPONSE" | jq -r '.rate_limit.primary_window.used_percent // 0')
WEEKLY=$(printf '%s' "$RESPONSE" | jq -r '.rate_limit.secondary_window.used_percent // 0')
RESET_AFTER=$(printf '%s' "$RESPONSE" | jq -r '.rate_limit.primary_window.reset_after_seconds // 0')
WEEKLY_RESET_AFTER=$(printf '%s' "$RESPONSE" | jq -r '.rate_limit.secondary_window.reset_after_seconds // 0')

USED_DISPLAY=$(( USED ))
if [ "$USED_DISPLAY" -lt 0 ]; then
  USED_DISPLAY=0
elif [ "$USED_DISPLAY" -gt 100 ]; then
  USED_DISPLAY=100
fi

WEEKLY_DISPLAY=$(( WEEKLY ))
if [ "$WEEKLY_DISPLAY" -lt 0 ]; then
  WEEKLY_DISPLAY=0
elif [ "$WEEKLY_DISPLAY" -gt 100 ]; then
  WEEKLY_DISPLAY=100
fi

COLOR="0xffe0def4"
MAX=$USED
RESET_AFTER_TO_USE="$RESET_AFTER"
if [ "$WEEKLY" -gt "$MAX" ] 2>/dev/null; then
  MAX=$WEEKLY
  RESET_AFTER_TO_USE="$WEEKLY_RESET_AFTER"
fi

COUNTDOWN="$(format_duration "$RESET_AFTER_TO_USE")"
LABEL="${USED_DISPLAY}%/${WEEKLY_DISPLAY}%"
if [ -n "$COUNTDOWN" ]; then
  LABEL="${LABEL} ${COUNTDOWN}"
fi

if [ "$MAX" -ge 90 ] 2>/dev/null; then
  COLOR="0xffeb6f92"
elif [ "$MAX" -ge 70 ] 2>/dev/null; then
  COLOR="0xfff6c177"
fi

if [ "${FETCH_FAILED:-0}" -ne 0 ] 2>/dev/null && [ -f "$CACHE_FILE" ]; then
  LABEL="${LABEL} stale"
fi

sketchybar --set "$NAME" label="$LABEL" label.color="$COLOR"
