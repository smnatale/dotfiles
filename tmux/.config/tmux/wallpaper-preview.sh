#!/usr/bin/env bash
set -euo pipefail

read -r cell_width cell_height < <(tmux display-message -p -c "$1" '#{client_cell_width} #{client_cell_height}')
columns=$FZF_PREVIEW_COLUMNS
lines=$FZF_PREVIEW_LINES

kitten icat --clear --stdin=no --unicode-placeholder --passthrough=none --transfer-mode=memory \
    --use-window-size="$columns,$lines,$((columns * cell_width)),$((lines * cell_height))" \
    --place="${columns}x${lines}@0x0" "$2"
printf '\n'
