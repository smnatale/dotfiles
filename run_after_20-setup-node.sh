#!/bin/sh

set -eu

brew_bin=/opt/homebrew/bin/brew
if [ ! -x "$brew_bin" ]; then
	printf '%s\n' 'Homebrew is required before Node.js can be installed.' >&2
	exit 1
fi

eval "$("$brew_bin" shellenv)"

if ! command -v fnm >/dev/null 2>&1; then
	printf '%s\n' 'fnm is required before Node.js can be installed.' >&2
	exit 1
fi

default_version="$(fnm default 2>/dev/null || true)"
if [ -n "$default_version" ] &&
	fnm exec --using="$default_version" node --version >/dev/null 2>&1; then
	exit 0
fi

eval "$(fnm env --shell bash)"
fnm install --lts --use
installed_version="$(fnm current)"

if [ -z "$installed_version" ] || [ "$installed_version" = system ]; then
	printf '%s\n' 'fnm installed Node.js but did not select the installed version.' >&2
	exit 1
fi

fnm default "$installed_version"
