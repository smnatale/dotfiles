#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$(realpath "${BASH_SOURCE[0]}")")/../../.."
export WALLPAPER_TMUX_CLIENT=${1:-}

if selected=$(fd --type f --extension jpg --extension jpeg --extension png --extension webp --print0 . wallpapers |
    fzf --read0 --no-multi --prompt='Wallpaper> ' --header='Enter to apply · Esc to cancel' \
        --preview='bash tmux/.config/tmux/wallpaper-preview.sh "$WALLPAPER_TMUX_CLIENT" {}' --preview-window=right,70%); then
    osascript - "$PWD/$selected" <<'APPLESCRIPT'
on run argv
    tell application "System Events"
        set picture of every desktop to item 1 of argv
    end tell
end run
APPLESCRIPT
else
    status=$?
    case "$status" in
        1|130) exit 0 ;;
        *) exit "$status" ;;
    esac
fi
