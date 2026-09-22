#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob dotglob

client=${1:-}
active=
if [[ -n ${TMUX:-} ]]; then
    if [[ -z $client ]]; then
        client=$(tmux display-message -p '#{client_name}')
    fi
    active=$(tmux display-message -p -c "$client" '#{session_name}')
fi
sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | LC_ALL=C sort || true)

selected=$(
    {
        while IFS= read -r session; do
            [[ -z $session || $session == "$active" ]] || printf '[session] %s\n' "$session"
        done <<< "$sessions"
        for group in work personal; do
            for directory in "$HOME/Projects/$group/"*/; do
                directory=${directory%/}
                label="$group/${directory##*/}"
                session=${label//[.:]/_}
                grep -Fxq -- "$session" <<< "$sessions" && continue
                printf '%s\n' "$label"
            done
        done
    } | fzf --no-sort --layout=reverse --prompt='Session> ' --delimiter='^\[session\] ' --nth=-1
) || exit 0
[[ -n $selected ]] || exit 0

if [[ $selected == '[session] '* ]]; then
    session=${selected#'[session] '}
else
    session=${selected//[.:]/_}
    tmux has-session -t "=$session" 2>/dev/null ||
        tmux new-session -d -s "$session" -c "$HOME/Projects/$selected"
fi

if [[ -n ${TMUX:-} ]]; then
    tmux switch-client -c "$client" -t "=$session"
else
    tmux attach-session -t "=$session"
fi
