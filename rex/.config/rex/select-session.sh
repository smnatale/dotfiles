#!/bin/sh
# Switch the Rex app this float was opened from to a session. Rex only allows
# this with Remote Control on (Settings > Rex Server), so fall back to a hint.
# Usage: select-session.sh <session-id> <label>
set -eu

client=$(rex api call session.list_clients "{\"session_id\":\"$REX_SESSION\"}" |
	jq -r '[.clients[] | select(.info.kind == "app")][0].client_id')
if ! rex -C "$client" do session.select session_id="$1" >/dev/null 2>&1; then
	printf '\nOpened session "%s".\nTurn on Remote Control in Rex Settings > Rex Server to switch to it automatically.\nPress Return to close.' "$2"
	read -r _
fi
