# options
setopt append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_expire_dups_first
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt no_beep
setopt inc_append_history

# env
source "$ZDOTDIR/.zshenv"

# plugins & plugin manager
source "$ZDOTDIR/plugins.zsh"

# aliases
source "$ZDOTDIR/aliases.zsh"

# fzf
source "$ZDOTDIR/fzf.zsh"

# history
HISTFILE=${ZDOTDIR}/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000
bindkey '^K' up-line-or-history
bindkey '^J' down-line-or-history
