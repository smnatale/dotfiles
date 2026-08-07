#!/usr/bin/env bash
set -euo pipefail

pane_dir=$(tmux display-message -p '#{pane_current_path}')
pane_id=$(tmux display-message -p '#{pane_id}')
pane_pid=$(tmux display-message -p '#{pane_pid}')

# Detect AI tools running in pane
ai_mode=false
pgrep -P "$pane_pid" -f "opencode|claude|codex" >/dev/null && ai_mode=true

# Find git root (fallback to pane_dir)
git_root=$(cd "$pane_dir" && git rev-parse --show-toplevel 2>/dev/null || echo "$pane_dir")

# Pick files with fd + fzf + bat preview
selected=$(
  cd "$git_root" && fd --type f --hidden --follow --exclude .git | \
    fzf --multi --height 100% --color=bg:#090B10,fg:#e0def4,hl:#c4a7e7,fg+:#e0def4,bg+:#403d52,hl+:#9ccfd8,info:#6e6a86,prompt:#31748f,pointer:#ebbcba,marker:#eb6f92,spinner:#f6c177,header:#6e6a86,border:#26233a --preview "bat --theme=rose-pine --style=numbers --color=always {}"
)

[ -z "$selected" ] && exit 0

# Format and send to pane
if $ai_mode; then
  printf -v output "@%s " $(echo "$selected")
else
  output=$(printf "%q " $(echo "$selected"))
fi

tmux send-keys -t "$pane_id" "$output"
