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

# Show the new session in the app this float was opened from. Rex only allows
# this with Remote Control on (Settings > Rex Server), so fall back to a hint.
client=$(rex api call session.list_clients "{\"session_id\":\"$REX_SESSION\"}" |
	jq -r '[.clients[] | select(.info.kind == "app")][0].client_id')
if ! rex -C "$client" do session.select session_id="$session" >/dev/null 2>&1; then
	printf '\nOpened session "%s".\nTurn on Remote Control in Rex Settings > Rex Server to switch to it automatically.\nPress Return to close.' "$branch"
	read -r _
fi
