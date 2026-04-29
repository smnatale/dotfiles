# Use vi keybindings.
set -o vi
bindkey -v

bindkey '^I' expand-or-complete
bindkey "^[[B" history-search-forward
bindkey "^[[A" history-search-backward
