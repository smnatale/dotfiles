# Homebrew - initialize shell environment (adds brew to PATH, sets MANPATH, etc.)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Environment variables for language runtimes and tools
export GOPATH="$HOME/go"                              # Go workspace directory
export BUN_INSTALL="$HOME/.bun"                       # Bun package manager install location
export JAVA_HOME="/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home"  # Zulu JDK 17
export ANDROID_HOME="$HOME/Library/Android/sdk"       # Android SDK root
export NODE_PATH="/usr/local/lib/node_modules"        # Global node_modules location

# PATH additions
export PATH="$HOME/scripts:$PATH"                     # Personal scripts
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH" # Neovim Mason LSP binaries
export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"  # PostgreSQL 17 CLI tools
export PATH="$HOME/.opencode/bin:$PATH"               # OpenCode CLI
export PATH="$GOPATH/bin:$PATH"                       # Go installed binaries
export PATH="/usr/local/go/bin:/usr/local/bin:$PATH"  # Go and Homebrew binaries
export PATH="$BUN_INSTALL/bin:$PATH"                  # Bun
export PATH="$ANDROID_HOME/emulator:$PATH"            # Android emulator
export PATH="$ANDROID_HOME/tools:$PATH"               # Android SDK tools
export PATH="$ANDROID_HOME/tools/bin:$PATH"           # Android SDK tools binaries
export PATH="$ANDROID_HOME/platform-tools:$PATH"      # Android adb, fastboot, etc.

# Rust/Cargo - source env if it exists
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

# rbenv - initialize Ruby version manager if available
if command -v rbenv >/dev/null 2>&1; then
	eval "$(rbenv init - --no-rehash zsh)"
fi

# Zsh options
setopt no_beep              # Disable terminal bell
setopt extended_glob        # Enable extended globbing (**, ~(foo|bar), etc.)
setopt auto_pushd           # cd pushes old dir onto the directory stack
setopt pushd_ignore_dups    # Don't push duplicate directories onto the stack
setopt interactive_comments # Allow # comments in interactive shell
setopt append_history       # Append to history file rather than overwrite
setopt share_history        # Share history across sessions in real time
setopt hist_ignore_space    # Don't record commands starting with a space
setopt hist_ignore_all_dups # Remove older duplicate entries from history
setopt hist_save_no_dups    # Don't save duplicate lines to history file
setopt hist_ignore_dups     # Don't record consecutive duplicate commands
setopt hist_find_no_dups    # Don't show duplicates when searching history
setopt hist_reduce_blanks   # Remove superfluous blanks from history entries
setopt prompt_subst         # Enable command substitution in prompt strings

# History configuration
HISTSIZE=5000              # Max number of commands in memory
HISTFILE="$HOME/.zsh_history"  # History file location
SAVEHIST=$HISTSIZE         # Max lines saved to history file
HISTDUP=erase              # Remove duplicates when loading history

# Completion system
autoload -Uz compinit       # Load completion system on demand (fast startup)
compinit                    # Initialize completion

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case-insensitive completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"  # Colorize completions like ls
zstyle ':completion:*' menu select                        # Arrow-key menu selection

# Vi mode - vi-style keybindings for command line editing
set -o vi                   # Enable vi mode
bindkey -v                  # Load vi keymap

# Keybindings
bindkey '^I' expand-or-complete        # Tab to complete
bindkey '^[[A' history-search-backward # Up arrow searches history
bindkey '^[[B' history-search-forward  # Down arrow searches history

# Short aliases
alias n='nvim'     # Neovim
alias lg='lazygit' # Lazygit TUI
alias oc='opencode' # OpenCode
alias cc='claude'  # Claude CLI
alias tms='~/.config/tmux/tmux-sessionizer.sh' # Tmux sessionizer
alias tmw='~/.config/tmux/tmux-worktree.sh'    # Tmux worktree

# fzf - fuzzy finder (Ctrl-T for file search, Ctrl-R for history, Alt-C for cd)
if (( $+commands[fzf] )); then
	source <(fzf --zsh)
fi

# zsh-autosuggestions - fish-style autosuggestions from history
if [[ -r "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
	source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# zsh-system-clipboard - copy/paste to system clipboard from vi mode
if [[ -r "/opt/homebrew/share/zsh-system-clipboard/zsh-system-clipboard.zsh" ]]; then
	source "/opt/homebrew/share/zsh-system-clipboard/zsh-system-clipboard.zsh"
fi

# Powerlevel10k - fast prompt theme
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f "$HOME/.p10k.zsh" ]] || source "$HOME/.p10k.zsh"  # Load p10k config if it exists

# zsh-syntax-highlighting - colorize commands as you type (must be sourced last)
if [[ -r "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
	source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# fnm - Fast Node Manager, auto-switch node versions on cd
if (( $+commands[fnm] )); then
	eval "$(fnm env --use-on-cd --shell zsh)"
fi

# Local overrides - machine-specific settings not checked into git
if [[ -r "$HOME/.zshrc.local" ]]; then
	source "$HOME/.zshrc.local"
fi
