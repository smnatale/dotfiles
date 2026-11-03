#!/bin/bash
# Compact status line: model | 5h | 7d | ctx | branch
# Catppuccin Mocha foregrounds only; background stays the terminal's.
input=$(cat)

fg() { printf '\033[38;2;%d;%d;%dm' "0x${1:0:2}" "0x${1:2:2}" "0x${1:4:2}"; }
RESET=$'\033[0m'
MAUVE=$(fg cba6f7)
GREEN=$(fg a6e3a1)
YELLOW=$(fg f9e2af)
RED=$(fg f38ba8)
SUBTEXT=$(fg a6adc8)
OVERLAY=$(fg 6c7086)
SAPPHIRE=$(fg 74c7ec)
TEAL=$(fg 94e2d5)

# Label in subtext, percentage colored green/yellow/red by usage.
pct() {
  local n color
  n=$(printf '%.0f' "$2")
  if [ "$n" -ge 80 ]; then color=$RED
  elif [ "$n" -ge 50 ]; then color=$YELLOW
  else color=$GREEN; fi
  printf '%s%s %s%s%%%s' "$SUBTEXT" "$1" "$color" "$n" "$RESET"
}

# One jq call, one field per line.
{ read -r model; read -r five; read -r week; read -r ctx; read -r dir; } < <(
  jq -r '
    .model.display_name,
    .rate_limits.five_hour.used_percentage,
    .rate_limits.seven_day.used_percentage,
    .context_window.used_percentage,
    (.workspace.current_dir // .cwd)
    | . // ""' <<< "$input")

parts=()
[ -n "$model" ] && parts+=("${MAUVE}${model}${RESET}")
[ -n "$five" ] && parts+=("$(pct 5h "$five")")
[ -n "$week" ] && parts+=("$(pct 7d "$week")")
[ -n "$ctx" ] && parts+=("$(pct ctx "$ctx")")

# Git status for the session dir, styled like the p10k prompt: branch ⇣1⇡2 *1 ~1 +1 !2 ?3
# (behind/ahead, stashes, conflicts, staged, unstaged, untracked). A branch icon marks the main
# checkout, a fork icon a linked worktree. Silent outside a repo.
if [ -n "$dir" ] && [ -d "$dir" ]; then
  g=(git -C "$dir" --no-optional-locks)
  if status=$("${g[@]}" status --porcelain=v2 --branch 2>/dev/null); then
    branch="" oid="" ahead=0 behind=0 staged=0 unstaged=0 untracked=0 conflicted=0
    while read -r kind a b c _; do
      case "$kind" in
        '#') case "$a" in
               branch.head) branch=$b ;;
               branch.oid) oid=$b ;;
               branch.ab) ahead=${b#+} behind=${c#-} ;;
             esac ;;
        1|2) [ "${a:0:1}" != . ] && staged=$((staged + 1))
             [ "${a:1:1}" != . ] && unstaged=$((unstaged + 1)) ;;
        u) conflicted=$((conflicted + 1)) ;;
        '?') untracked=$((untracked + 1)) ;;
      esac
    done <<< "$status"
    [ "$branch" = "(detached)" ] && branch="@${oid:0:8}"
    stashes=$("${g[@]}" rev-list --walk-reflogs --count refs/stash 2>/dev/null)
    { read -r gdir; read -r cdir; } < <("${g[@]}" rev-parse --path-format=absolute --git-dir --git-common-dir)
    icon=$'\xee\x82\xa0'  # nf branch
    [ "$gdir" != "$cdir" ] && icon=$'\xef\x90\x82'  # nf fork

    seg="${SAPPHIRE}${icon} ${branch}"
    if [ "$behind" -gt 0 ] || [ "$ahead" -gt 0 ]; then
      seg+=" "
      [ "$behind" -gt 0 ] && seg+="⇣${behind}"
      [ "$ahead" -gt 0 ] && seg+="⇡${ahead}"
    fi
    [ "${stashes:-0}" -gt 0 ] && seg+=" *${stashes}"
    [ "$conflicted" -gt 0 ] && seg+=" ${RED}~${conflicted}"
    [ "$staged" -gt 0 ] && seg+=" ${YELLOW}+${staged}"
    [ "$unstaged" -gt 0 ] && seg+=" ${YELLOW}!${unstaged}"
    [ "$untracked" -gt 0 ] && seg+=" ${TEAL}?${untracked}"
    parts+=("${seg}${RESET}")
  fi
fi

sep=" ${OVERLAY}│${RESET} "
out=""
for p in "${parts[@]}"; do
  [ -n "$out" ] && out="$out$sep$p" || out="$p"
done
printf '%s\n' "$out"
