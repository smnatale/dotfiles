#!/bin/bash
# Compact status line: model | 5h | 7d | ctx | permission mode
# Catppuccin Mocha foregrounds only; background stays the terminal's.
input=$(cat)
j() { echo "$input" | jq -r "$1 // empty"; }

fg() { printf '\033[38;2;%d;%d;%dm' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
RESET=$'\033[0m'
MAUVE=$(fg cba6f7)
PEACH=$(fg fab387)
GREEN=$(fg a6e3a1)
YELLOW=$(fg f9e2af)
RED=$(fg f38ba8)
SUBTEXT=$(fg a6adc8)
OVERLAY=$(fg 6c7086)

# Label in subtext, percentage colored green/yellow/red by usage.
pct() {
  local n color
  n=$(printf '%.0f' "$2")
  if [ "$n" -ge 80 ]; then color=$RED
  elif [ "$n" -ge 50 ]; then color=$YELLOW
  else color=$GREEN; fi
  printf '%s%s %s%s%%%s' "$SUBTEXT" "$1" "$color" "$n" "$RESET"
}

model=$(j '.model.display_name')
five=$(j '.rate_limits.five_hour.used_percentage')
week=$(j '.rate_limits.seven_day.used_percentage')
ctx=$(j '.context_window.used_percentage')
# Not in the documented schema; best-effort guesses, omitted if absent.
mode=$(j '.permission_mode // .permissionMode // .permissions.mode')

parts=()
[ -n "$model" ] && parts+=("${MAUVE}${model}${RESET}")
[ -n "$five" ] && parts+=("$(pct 5h "$five")")
[ -n "$week" ] && parts+=("$(pct 7d "$week")")
[ -n "$ctx" ] && parts+=("$(pct ctx "$ctx")")
[ -n "$mode" ] && parts+=("${PEACH}${mode}${RESET}")

sep=" ${OVERLAY}│${RESET} "
out=""
for p in "${parts[@]}"; do
  [ -n "$out" ] && out="$out$sep$p" || out="$p"
done
printf '%s\n' "$out"
