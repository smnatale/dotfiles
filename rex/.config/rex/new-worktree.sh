#!/bin/sh
# Ask for a branch, create its worktree with wt, open a Rex session there running
# claude, and switch the app to it. Run by the "New Worktree" palette action.
set -eu

printf 'New worktree branch: '
read -r branch
[ -n "$branch" ] || exit 0

# wt fills in the templates; the session is labelled repo/branch so wt's
# post-remove hook can find it again.
session=$(wt switch --create "$branch" --no-cd -x rex -- \
	new '{{ repo }}/{{ branch }}' -c '{{ worktree_path }}' --window claude --json \
	-- sh -c 'claude; exec "$SHELL"' | jq -r '.session_id')

"$(dirname "$0")/select-session.sh" "$session" "$branch"
