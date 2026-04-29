typeset -g ZSH_CONFIG_DIR="${ZDOTDIR:-$HOME}/.config/zsh"

source "${ZSH_CONFIG_DIR}/helpers.zsh"

source_if_exists "${ZSH_CONFIG_DIR}/oh-my-zsh.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/completion.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/plugins.zsh"

(( $+functions[load_pre_prompt_plugins] )) && load_pre_prompt_plugins

source_if_exists "${ZSH_CONFIG_DIR}/history.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/keybindings.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/atuin.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/aliases.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/tooling.zsh"
source_if_exists "${ZSH_CONFIG_DIR}/prompt.zsh"

# Local overrides.
source_if_exists "$HOME/.zshrc.local"

# Syntax highlighting must load after every widget/plugin that mutates ZLE.
(( $+functions[load_syntax_highlighting] )) && load_syntax_highlighting
