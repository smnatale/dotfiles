#!/usr/bin/env bash
set -euo pipefail

pane_id=${1:-$(tmux display-message -p '#{pane_id}')}
start_dir=${2:-$(tmux display-message -p -t "$pane_id" '#{pane_current_path}')}

cd "$start_dir"

cursor_row=$(tmux display-message -p -t "$pane_id" '#{e|+:#{pane_top},#{cursor_y}}')
popup_height=$(tput lines)
layout=reverse
if (( cursor_row >= popup_height )); then
    layout=default
fi

if selected_path=$({ fd --type f --hidden --exclude .git --strip-cwd-prefix --print0 . || [[ $? == 141 ]]; } |
    fzf --read0 --print0 --no-multi --no-preview --layout="$layout" --scheme=path --prompt='File> ' |
    while IFS= read -r -d '' path; do
        printf '%q' "$path"
    done); then
    [[ -z $selected_path ]] && exit 0

    buffer_name="file-picker-${pane_id#%}"
    tmux set-buffer -b "$buffer_name" "$selected_path"
    tmux paste-buffer -d -p -b "$buffer_name" -t "$pane_id"
else
    picker_status=$?
    # fzf returns 1 for no match and 130 when cancelled.
    case "$picker_status" in
        1|130) exit 0 ;;
        *) exit "$picker_status" ;;
    esac
fi
