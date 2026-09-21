# zsh plugin manager
source /opt/homebrew/opt/zinit/zinit.zsh

# super smart autocompletions
zinit ice wait"0" lucid depth=1 pick"deja.plugin.zsh"
zinit light Giammarco-Ferranti/deja

# syntax highlighting
zinit light zsh-users/zsh-syntax-highlighting

# pretty prompt
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
