#!/bin/sh

set -eu

if ! command -v atuin >/dev/null 2>&1; then
	printf '%s\n' 'Atuin is required before history can be imported.' >&2
	exit 1
fi

if [ -f "$HOME/.zsh_history" ]; then
	HISTFILE="$HOME/.zsh_history" atuin import zsh
fi
