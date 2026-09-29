# zsh plugin manager
source /opt/homebrew/opt/zinit/zinit.zsh

autoload -Uz compinit
compinit

# super smart autocompletions
zinit ice wait"0" lucid depth=1 pick"deja.plugin.zsh"
zinit light Giammarco-Ferranti/deja

# syntax highlighting
zinit ice as"program" from"gh-r" pick"zsh-patina-*/zsh-patina" atload'eval "$(zsh-patina activate)" && eval "$(zsh-patina completion)"'
zinit light michel-kraemer/zsh-patina

# pretty prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
