#!/usr/bin/env bash
set -euo pipefail

script_directory=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
cd "$script_directory/../../.."

export WALLPAPER_TMUX_CLIENT=${1:-}

# shellcheck disable=SC2016 # fzf expands the client variable when it runs the preview.
selected_wallpaper=$(
    fd --type f \
        --extension jpg \
        --extension jpeg \
        --extension png \
        --extension webp \
        --print0 . wallpapers |
        fzf \
            --read0 \
            --no-multi \
            --prompt='Wallpaper> ' \
            --header='Enter to apply · Esc to cancel' \
            --preview='bash tmux/.config/tmux/wallpaper-preview.sh "$WALLPAPER_TMUX_CLIENT" {}' \
            --preview-window=right,70%
) || {
    picker_status=$?
    # fzf returns 1 for no match and 130 when cancelled.
    case "$picker_status" in
        1 | 130) exit 0 ;;
        *) exit "$picker_status" ;;
    esac
}

osascript - "$PWD/$selected_wallpaper" <<'APPLESCRIPT'
on run argv
    tell application "System Events"
        set picture of every desktop to item 1 of argv
    end tell
end run
APPLESCRIPT
