#!/usr/bin/env bash
set -euo pipefail

paths="${TMUX_SESSIONIZER_PATHS:-$HOME}"
default_depth="${TMUX_SESSIONIZER_DEPTH:-1}"
current_session=""
current_path="$PWD"

if [ -n "${TMUX:-}" ]; then
  current_session=$(tmux display-message -p '#S' 2>/dev/null || true)
  current_path=$(tmux display-message -p '#{pane_current_path}' 2>/dev/null || printf '%s' "$PWD")
fi

current_repo=$(git -C "$current_path" rev-parse --show-toplevel 2>/dev/null || true)
[ -n "$current_repo" ] && current_repo=$(cd -P "$current_repo" && pwd)

expand_tilde() { printf '%s\n' "${1/#~/$HOME}"; }

add_repo() {
  local directory repo
  directory="$1"
  repo=$(git -C "$directory" rev-parse --show-toplevel 2>/dev/null) || return 0
  repo=$(cd -P "$repo" && pwd) || return 0
  [ "$repo" = "$current_repo" ] && return 0
  printf '%s\n' "${repo/#$HOME/~}"
}

selected=$(
  {
    # Existing tmux sessions
    tmux list-sessions -F '#{session_name}' 2>/dev/null | while IFS= read -r sess; do
      [ "$sess" = "$current_session" ] && continue
      printf '[TMUX] %s\n' "$sess"
    done || true

    # Discover Git roots. Paths are newline-separated and may end in :depth.
    while IFS= read -r entry; do
      # Extract optional depth suffix (e.g., ~/foo:2)
      [[ "$entry" =~ ^([^:]+):([0-9]+)$ ]] && path="${BASH_REMATCH[1]}" depth="${BASH_REMATCH[2]}" || { path="$entry"; depth="$default_depth"; }
      path=$(expand_tilde "$path")
      [ -z "$entry" ] && continue
      [ -d "$path" ] || continue
      path=$(cd -P "$path" && pwd) || continue
      add_repo "$path"
      while IFS= read -r -d '' directory; do
        add_repo "$directory"
      done < <(fd --type d --hidden --exclude .git --max-depth "$depth" --print0 . "$path")
    done <<< "$paths"
  } | sort -u | fzf --height 100% --color=bg:-1,fg:#e0def4,hl:#c4a7e7,fg+:#e0def4,bg+:#403d52,hl+:#9ccfd8,info:#6e6a86,prompt:#31748f,pointer:#ebbcba,spinner:#f6c177,header:#6e6a86,border:#26233a
)

[ -z "$selected" ] && exit 0
selected=$(expand_tilde "$selected")

# If existing session selected, switch to it
if [[ "$selected" =~ ^\[TMUX\]\ (.+)$ ]]; then
  sess="${BASH_REMATCH[1]}"
  [ -z "${TMUX:-}" ] && tmux attach -t "$sess" || tmux switch-client -t "$sess"
  exit 0
fi

# Otherwise, create and switch/attach. Add a stable suffix if the basename
# already belongs to a different repository.
repo_name=$(basename "$selected")
repo_name=${repo_name// /-}
repo_name=$(printf '%s' "$repo_name" | tr -cd '[:alnum:]_.-')
sess="$repo_name"
if tmux has-session -t "=$sess" 2>/dev/null; then
  existing_path=$(tmux list-panes -t "=$sess:0" -F '#{pane_current_path}' 2>/dev/null | head -n 1 || true)
  existing_repo=$(git -C "$existing_path" rev-parse --show-toplevel 2>/dev/null || true)
  [ -n "$existing_repo" ] && existing_repo=$(cd -P "$existing_repo" && pwd)
  if [ "$existing_repo" != "$selected" ]; then
    suffix=$(printf '%s' "$selected" | cksum | cut -d ' ' -f 1)
    sess="${repo_name}-${suffix}"
  fi
fi

if [ -z "${TMUX:-}" ]; then
  tmux has-session -t "$sess" 2>/dev/null || tmux new-session -ds "$sess" -c "$selected"
  tmux attach -t "$sess"
else
  tmux has-session -t "$sess" 2>/dev/null || tmux new-session -ds "$sess" -c "$selected"
  tmux switch-client -t "$sess"
fi
