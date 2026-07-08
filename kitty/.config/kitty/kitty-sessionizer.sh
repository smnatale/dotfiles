#!/usr/bin/env bash

PATH="/opt/homebrew/bin:$PATH"
export PATH

projects_dir="$HOME/Projects"

kitty_data=$(kitten @ ls 2>/dev/null)
if [[ -z "$kitty_data" ]]; then
    echo "Failed to connect to kitty" >&2
    exit 1
fi

open_paths=$(
    printf "%s" "$kitty_data" | jq -r '
        .[]?.tabs[]?.windows[]?
        | select(.session_name? != "")
        | (.env.PWD // .cwd // empty)
    ' 2>/dev/null | sort -u
)

menu=$(
    current_cwd=$(printf "%s" "$kitty_data" | jq -r '
        [.[]?.tabs[]?.windows[]?
        | select(.session_name? != "" and .is_self != true)]
        | sort_by(-(.last_focused_at // 0))
        | .[0] | (.env.PWD // .cwd // "")
    ' 2>/dev/null)

    printf "%s" "$kitty_data" | jq -r --arg cur "$current_cwd" '
        [.[]?.tabs[]?.windows[]?
        | select(.session_name? != "" and .is_self != true)
        | {name: .session_name, cwd: (.env.PWD // .cwd // ""), last: (.last_focused_at // 0)}]
        | group_by(.cwd)
        | map(sort_by(-.last) | .[0])
        | sort_by(-.last)
        | .[] | select(.cwd != $cur)
        | "[switch]  \(.name)  \(.cwd)" + "\t" + .cwd
    ' 2>/dev/null

    find "$projects_dir" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | while IFS= read -r path; do
        base=$(basename "$path")
        if echo "$open_paths" | grep -qxF "$path"; then
            continue
        fi
        printf "[new]  %s  %s\t%s\n" "$base" "$path" "$path"
    done
)

selected=$(echo "$menu" | fzf --height=100% --prompt="> " --delimiter=$'\t' --with-nth=1)
[[ -z "$selected" ]] && exit 0

path=$(echo "$selected" | awk -F'\t' '{print $2}')
base=$(basename "$path")
session_dir="${XDG_CACHE_HOME:-$HOME/.cache}/kitty-sessionizer/sessions"
mkdir -p "$session_dir"
session_file="$session_dir/$base.kitty-session"

cat >"$session_file" <<EOF
# kitty-sessionizer-path: $path
layout tall
cd $path
launch --title "$base"
focus
EOF

kitten @ action goto_session "$session_file" 2>/dev/null || kitten @ launch --type=tab --cwd="$path" --title="$base"
