# Atuin replaces Ctrl-R and history search widgets when available.
if (( $+commands[atuin] )); then
	eval "$(atuin init zsh)"
fi
