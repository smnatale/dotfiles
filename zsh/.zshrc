eval "$(/opt/homebrew/bin/brew shellenv)"

export GOPATH="$HOME/go"
export BUN_INSTALL="$HOME/.bun"
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export NODE_PATH="/usr/local/lib/node_modules"

export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export PATH="$HOME/.opencode/bin:$PATH"
export PATH="$GOPATH/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$ANDROID_HOME/emulator:$PATH"
export PATH="$ANDROID_HOME/tools:$PATH"
export PATH="$ANDROID_HOME/tools/bin:$PATH"
export PATH="$ANDROID_HOME/platform-tools:$PATH"

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

if command -v rbenv >/dev/null 2>&1; then
	eval "$(rbenv init - --no-rehash zsh)"
fi

setopt no_beep
setopt auto_cd
setopt extended_glob
setopt auto_pushd
setopt pushd_ignore_dups
setopt interactive_comments
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt prompt_subst

HISTSIZE=5000
HISTFILE="$HOME/.zsh_history"
SAVEHIST=$HISTSIZE
HISTDUP=erase

autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

set -o vi
bindkey -v

bindkey '^I' expand-or-complete
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

alias n='nvim'
alias lg='lazygit'
alias oc='opencode'
alias cc='claude'

if (( $+commands[fzf] )); then
	source <(fzf --zsh)
fi

if [[ -r "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

if [[ -r "/opt/homebrew/share/zsh-system-clipboard/zsh-system-clipboard.zsh" ]]; then
	source "/opt/homebrew/share/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"

if [[ -r "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
	source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

if (( $+commands[fnm] )); then
	eval "$(fnm env --use-on-cd --shell zsh)"
fi

if [[ -r "$HOME/.zshrc.local" ]]; then
	source "$HOME/.zshrc.local"
fi
