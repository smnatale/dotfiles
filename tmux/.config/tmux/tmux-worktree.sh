#!/usr/bin/env bash
set -euo pipefail

PROJECTS_DIR="$HOME/Projects"

project_dir=$(find "$PROJECTS_DIR" -mindepth 1 -maxdepth 1 -type d | fzf --height 100% --prompt="Project> ")
[ -z "$project_dir" ] && exit 0
project_name=$(basename "$project_dir")

cd "$project_dir"

if [ ! -d .git ] && [ ! -f .git ]; then
  echo "Not a git repo: $project_dir"
  read -r -p "Press enter to close..."
  exit 1
fi

git worktree prune 2>/dev/null || true

branches=$(git branch --format='%(refname:short)')
selection=$(printf '%s\n[new branch]\n' "$branches" | fzf --height 100% --prompt="Branch> ")
[ -z "$selection" ] && exit 0

if [ "$selection" = "[new branch]" ]; then
  read -r -p "New branch name: " branch
  [ -z "$branch" ] && exit 0
  is_new=true
else
  branch="$selection"
  is_new=false
fi

wt_root="$project_dir/.worktrees"
mkdir -p "$wt_root"
if ! grep -qxF '.worktrees/' .gitignore 2>/dev/null; then
  echo '.worktrees/' >> .gitignore
fi

wt_path="$wt_root/$branch"

existing_path=$(git worktree list --porcelain | awk -v b="refs/heads/$branch" '
  /^worktree / { path=$2 }
  $0 == "branch " b { print path }
')

if [ -n "$existing_path" ]; then
  wt_path="$existing_path"
elif [ -d "$wt_path" ]; then
  echo "Directory exists but isn't a registered worktree: $wt_path"
  read -r -p "Press enter to close..."
  exit 1
else
  if [ "$is_new" = true ]; then
    git worktree add "$wt_path" -b "$branch"
  else
    git worktree add "$wt_path" "$branch"
  fi
fi

sanitized_branch=$(echo "$branch" | tr '.:/ ' '----')
sess_name="${project_name}(${sanitized_branch})"

tmux has-session -t "$sess_name" 2>/dev/null || tmux new-session -d -s "$sess_name" -c "$wt_path"

if [ -z "${TMUX:-}" ]; then
  tmux attach -t "$sess_name"
else
  tmux switch-client -t "$sess_name"
fi
