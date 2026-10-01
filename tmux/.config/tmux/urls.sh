#!/usr/bin/env bash
set -euo pipefail

pane_id=${1:-$(tmux display-message -p '#{pane_id}')}
pane_content=$(tmux capture-pane -p -J -S - -t "$pane_id")

# grep returns 1 when no URLs match, which is not an error here.
urls=$(printf '%s\n' "$pane_content" |
    { grep -Eo "https?://[^[:space:]<>\"'\`]+" || [[ $? == 1 ]]; } |
    sed -E 's/[]).,;:!?}]+$//' |
    sort -u)

if [[ -z $urls ]]; then
    tmux display-message -t "$pane_id" 'No URLs in this pane'
    exit 0
fi

selected_url=$(printf '%s\n' "$urls" |
    fzf \
        --no-multi \
        --no-preview \
        --layout=reverse \
        --prompt='URL> ') || {
    picker_status=$?
    # fzf returns 1 for no match and 130 when cancelled.
    case "$picker_status" in
        1 | 130) exit 0 ;;
        *) exit "$picker_status" ;;
    esac
}

[[ -z $selected_url ]] || open "$selected_url"
