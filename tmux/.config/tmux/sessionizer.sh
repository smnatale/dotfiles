#!/usr/bin/env bash
set -euo pipefail

shopt -s nullglob dotglob

client_name=${1:-}
active_session=
if [[ -n ${TMUX:-} ]]; then
    if [[ -z $client_name ]]; then
        client_name=$(tmux display-message -p '#{client_name}')
    fi
    active_session=$(tmux display-message -p -c "$client_name" '#{session_name}')
fi
existing_sessions=$(tmux list-sessions -F '#{session_name}' 2>/dev/null | LC_ALL=C sort || true)

selected=$(
    {
        while IFS= read -r session_name; do
            if [[ -n $session_name && $session_name != "$active_session" ]]; then
                printf '[session] %s\n' "$session_name"
            fi
        done <<< "$existing_sessions"

        for group in work personal; do
            for directory in "$HOME/Projects/$group/"*/; do
                directory=${directory%/}
                project="$group/${directory##*/}"
                session_name=${project//[.:]/_}
                if grep -Fxq -- "$session_name" <<< "$existing_sessions"; then
                    continue
                fi
                printf '%s\n' "$project"
            done
        done
    } | fzf --no-sort --layout=reverse --prompt='Session> ' \
        --delimiter='^\[session\] ' --nth=-1
) || exit 0
if [[ -z $selected ]]; then
    exit 0
fi

if [[ $selected == '[session] '* ]]; then
    session_name=${selected#'[session] '}
else
    session_name=${selected//[.:]/_}
    if ! tmux has-session -t "=$session_name" 2>/dev/null; then
        tmux new-session -d -s "$session_name" -c "$HOME/Projects/$selected"
    fi
fi

if [[ -n ${TMUX:-} ]]; then
    tmux switch-client -c "$client_name" -t "=$session_name"
else
    tmux attach-session -t "=$session_name"
fi
