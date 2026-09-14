#!/bin/sh

set -eu

brew_bin=/opt/homebrew/bin/brew
if [ ! -x "$brew_bin" ]; then
	printf '%s\n' 'Homebrew is required before packages can be installed.' >&2
	exit 1
fi

eval "$("$brew_bin" shellenv)"

if ! brew bundle check --file="$HOME/.Brewfile" --no-upgrade; then
	brew bundle install --file="$HOME/.Brewfile" --no-upgrade
fi
