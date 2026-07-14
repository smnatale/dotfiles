#!/usr/bin/env bash
set -euo pipefail

PROJECTS_DIR="$HOME/Projects"

# Menu lines: display_label<TAB>session_name<TAB>path<TAB>type
menu=""

# 1. Existing tmux sessions (skip worktree sessions, handled in section 3)
if tmux ls &>/dev/null; then
  while IFS= read -r sess; do
    [[ "$sess" == *"("* ]] && continue
    menu+="[switch] ${sess}"$'\t'"${sess}"$'\t'"$sess"$'\t'"switch"$'\n'
  done < <(tmux list-sessions -F '#{session_name}')
fi

# 2. Top-level projects not already a session
for dir in "$PROJECTS_DIR"/*/; do
  [ -d "$dir" ] || continue
  name=$(basename "$dir")
  tmux has-session -t "$name" 2>/dev/null && continue
  menu+="[new] ${name}"$'\t'"${name}"$'\t'"${dir}"$'\t'"new"$'\n'
done

# 3. Worktrees inside each project's .worktrees/
for dir in "$PROJECTS_DIR"/*/; do
  { [ -d "$dir/.git" ] || [ -f "$dir/.git" ]; } || continue
  (cd "$dir" && git worktree prune 2>/dev/null) || true
  wt_dir="${dir}.worktrees"
  [ -d "$wt_dir" ] || continue
  project_name=$(basename "$dir")
  for branch_dir in "$wt_dir"/*/; do
    [ -d "$branch_dir" ] || continue
    branch_name=$(basename "$branch_dir")
    sess_name="${project_name}(${branch_name})"
    if tmux has-session -t "$sess_name" 2>/dev/null; then
      label="[switch] ${project_name} (${branch_name})"
      type="switch"
    else
      label="[new] ${project_name} (${branch_name}) [worktree]"
      type="new"
    fi
    menu+="${label}"$'\t'"${sess_name}"$'\t'"${branch_dir}"$'\t'"${type}"$'\n'
  done
done

[ -z "$menu" ] && exit 0

selection=$(printf '%s' "$menu" | sort -t$'\t' -k4,4 -k1,1 | fzf --height 100% --delimiter=$'\t' --with-nth=1)
[ -z "$selection" ] && exit 0

sess=$(printf '%s' "$selection" | cut -f2)
path=$(printf '%s' "$selection" | cut -f3)
type=$(printf '%s' "$selection" | cut -f4)

if [ "$type" = "switch" ]; then
  if [ -z "${TMUX:-}" ]; then
    tmux attach -t "$sess"
  else
    tmux switch-client -t "$sess"
  fi
else
  if [ -z "${TMUX:-}" ]; then
    tmux new-session -s "$sess" -c "$path"
  else
    tmux new-session -d -s "$sess" -c "$path"
    tmux switch-client -t "$sess"
  fi
fi
