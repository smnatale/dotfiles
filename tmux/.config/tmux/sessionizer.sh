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

selected_entry=$(
    {
        while IFS= read -r session_name; do
            if [[ -n $session_name && $session_name != "$active_session" ]]; then
                printf '[session] %s\n' "$session_name"
            fi
        done <<<"$existing_sessions"

        for project_directory in "$HOME/Projects/"{work,personal}/*/; do
            project_path=${project_directory#"$HOME/Projects/"}
            project_path=${project_path%/}
            # tmux session names cannot contain periods or colons.
            session_name=${project_path//[.:]/_}
            if ! grep -Fxq -- "$session_name" <<<"$existing_sessions"; then
                printf '%s\n' "$project_path"
            fi
        done
    } | fzf \
        --no-sort \
        --layout=reverse \
        --prompt='Session> ' \
        --delimiter='^\[session\] ' \
        --nth=-1
) || exit 0

if [[ -z $selected_entry ]]; then
    exit 0
fi

if [[ $selected_entry == '[session] '* ]]; then
    session_name=${selected_entry#'[session] '}
else
    session_name=${selected_entry//[.:]/_}
    # The leading '=' requires an exact session name instead of a prefix match.
    if ! tmux has-session -t "=$session_name" 2>/dev/null; then
        tmux new-session -d -s "$session_name" -c "$HOME/Projects/$selected_entry"
    fi
fi

if [[ -n ${TMUX:-} ]]; then
    tmux switch-client -c "$client_name" -t "=$session_name"
else
    tmux attach-session -t "=$session_name"
fi
