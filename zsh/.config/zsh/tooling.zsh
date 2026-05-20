export PATH="$HOME/.local/bin:$PATH"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:/usr/local/go/bin:$GOPATH/bin"

# Android / React Native
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/tools/bin"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"

# PostgreSQL
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Node
export NODE_PATH="/usr/local/lib/node_modules"
if command -v fzf >/dev/null 2>&1; then
	eval "$(fzf --zsh)"
fi

source_if_exists "$HOME/scripts/fzf-git.sh"
source_if_exists "$HOME/.bun/_bun"

eval "$(fnm env --use-on-cd --shell zsh)"
