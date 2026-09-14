#!/bin/sh

set -eu
umask 077

ssh_dir="$HOME/.ssh"
private_key="$ssh_dir/id_ed25519"
public_key="$private_key.pub"

if ! command -v ssh-keygen >/dev/null 2>&1; then
	printf '%s\n' 'ssh-keygen is required to set up GitHub SSH access.' >&2
	exit 1
fi

mkdir -p "$ssh_dir"
chmod 700 "$ssh_dir"

if [ -e "$private_key" ]; then
	if [ ! -e "$public_key" ]; then
		printf '%s\n' 'Deriving the missing public key from the existing private key.'
		ssh-keygen -y -f "$private_key" > "$public_key"
	fi
elif [ -e "$public_key" ]; then
	printf '%s\n' 'A public key exists without its private key. Refusing to create a new key.' >&2
	exit 1
else
	printf '%s\n' 'No GitHub SSH key found. Creating an Ed25519 key.'
	ssh-keygen -t ed25519 -f "$private_key" -C 'github-ssh'
fi

chmod 600 "$private_key"
chmod 644 "$public_key"

printf '\n%s\n' 'GitHub SSH key ready:'
ssh-keygen -lf "$public_key"
printf '\n%s\n' 'Add this public key to GitHub if it is not already registered:'
cat "$public_key"
printf '%s\n' 'https://github.com/settings/keys'
