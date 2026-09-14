#!/bin/sh

set -eu

if [ -x /opt/homebrew/bin/brew ]; then
	exit 0
fi

installer="$(mktemp "${TMPDIR:-/tmp}/homebrew-install.XXXXXX")"
trap 'rm -f "$installer"' EXIT HUP INT TERM

/usr/bin/curl --fail --silent --show-error --location \
	https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh \
	--output "$installer"
/bin/bash "$installer"

if [ ! -x /opt/homebrew/bin/brew ]; then
	printf '%s\n' 'Homebrew installation completed without creating a supported brew executable.' >&2
	exit 1
fi
