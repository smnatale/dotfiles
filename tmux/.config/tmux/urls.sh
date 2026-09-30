#!/usr/bin/env bash
set -euo pipefail

pane=${1:-$(tmux display-message -p '#{pane_id}')}
content=$(tmux capture-pane -p -J -S - -t "$pane")
urls=$(printf '%s\n' "$content" |
    { grep -Eo "https?://[^[:space:]<>\"'\`]+" || [[ $? == 1 ]]; } |
    sed -E 's/[]).,;:!?}]+$//' |
    sort -u)

if [[ -z $urls ]]; then
    tmux display-message -t "$pane" 'No URLs in this pane'
    exit 0
fi

if selected=$(printf '%s\n' "$urls" |
    fzf --no-multi --no-preview --layout=reverse --prompt='URL> '); then
    [[ -z $selected ]] || open "$selected"
else
    status=$?
    case "$status" in
        1|130) exit 0 ;;
        *) exit "$status" ;;
    esac
fi
