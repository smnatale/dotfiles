#!/usr/bin/env bash
set -euo pipefail

client_name=$1
wallpaper_path=$2

read -r cell_width cell_height < <(
    tmux display-message -p -c "$client_name" '#{client_cell_width} #{client_cell_height}'
)
preview_columns=$FZF_PREVIEW_COLUMNS
preview_rows=$FZF_PREVIEW_LINES
preview_width_pixels=$((preview_columns * cell_width))
preview_height_pixels=$((preview_rows * cell_height))

kitten icat \
    --clear \
    --stdin=no \
    --unicode-placeholder \
    --passthrough=none \
    --transfer-mode=memory \
    --use-window-size="$preview_columns,$preview_rows,$preview_width_pixels,$preview_height_pixels" \
    --place="${preview_columns}x${preview_rows}@0x0" \
    "$wallpaper_path"
printf '\n'
