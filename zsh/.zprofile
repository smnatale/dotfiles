if command -v /opt/homebrew/bin/brew >/dev/null 2>&1; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
elif command -v brew >/dev/null 2>&1; then
	eval "$(brew shellenv)"
fi

export LANG=en_US.UTF-8

path_prepend() {
	export PATH="$1:$PATH"
}

path_append() {
	export PATH="$PATH:$1"
}

# Login-shell paths and machine-specific tools.
path_prepend "$HOME/scripts"
path_prepend "$HOME/.local/share/nvim/mason/bin"
path_prepend "/opt/homebrew/opt/postgresql@17/bin"
path_prepend "$HOME/.opencode/bin"

export GOPATH="$HOME/go"
path_prepend "$GOPATH/bin"

export BUN_INSTALL="$HOME/.bun"
path_prepend "$BUN_INSTALL/bin"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

unfunction path_prepend path_append

if command -v rbenv >/dev/null 2>&1; then
	eval "$(rbenv init - --no-rehash zsh)"
fi
