#!/usr/bin/env bash
set -euo pipefail

paths="${TMUX_SESSIONIZER_PATHS:-$HOME}"
default_depth="${TMUX_SESSIONIZER_DEPTH:-1}"

expand_tilde() { echo "${1/#~/$HOME}"; }

selected=$(
  {
    # Existing tmux sessions
    tmux list-sessions -F '[TMUX] #{session_name}' 2>/dev/null || true

    # Discovered directories from paths
    for entry in $paths; do
      # Extract optional depth suffix (e.g., ~/foo:2)
      [[ "$entry" =~ ^([^:]+):([0-9]+)$ ]] && path="${BASH_REMATCH[1]}" depth="${BASH_REMATCH[2]}" || { path="$entry"; depth="$default_depth"; }
      path=$(expand_tilde "$path")
      for expanded in $path; do
        [ -d "$expanded" ] || continue
        find "$expanded" -mindepth 1 -maxdepth "$depth" -type d | sed "s|^$HOME|~|"
      done
    done
  } | fzf --height 100% --color=bg:#090B10,fg:#e0def4,hl:#c4a7e7,fg+:#e0def4,bg+:#403d52,hl+:#9ccfd8,info:#6e6a86,prompt:#31748f,pointer:#ebbcba,marker:#eb6f92,spinner:#f6c177,header:#6e6a86,border:#26233a
)

[ -z "$selected" ] && exit 0
selected=$(expand_tilde "$selected")

# If existing session selected, switch to it
if [[ "$selected" =~ ^\[TMUX\]\ (.+)$ ]]; then
  sess="${BASH_REMATCH[1]}"
  [ -z "${TMUX:-}" ] && tmux attach -t "$sess" || tmux switch-client -t "$sess"
  exit 0
fi

# Otherwise, create and switch/attach
sess=$(basename "$selected")
if [ -z "${TMUX:-}" ]; then
  tmux has-session -t "$sess" 2>/dev/null || tmux new-session -ds "$sess" -c "$selected"
  tmux attach -t "$sess"
else
  tmux has-session -t "$sess" 2>/dev/null || tmux new-session -ds "$sess" -c "$selected"
  tmux switch-client -t "$sess"
fi
