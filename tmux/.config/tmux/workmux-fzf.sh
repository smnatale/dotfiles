#!/usr/bin/env bash
cmd="$1"
[ -z "$cmd" ] && exit 1

selection=$(workmux list | tail -n +2 | fzf)
[ -z "$selection" ] && exit 0

branch=$(echo "$selection" | awk '{print $1}')
workmux "$cmd" "$branch" || { echo; echo "workmux $cmd failed. Press any key to close."; read -n 1 -s; }
