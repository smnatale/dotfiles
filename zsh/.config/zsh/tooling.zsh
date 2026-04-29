if command -v fzf >/dev/null 2>&1; then
	eval "$(fzf --zsh)"
fi

source_if_exists "$HOME/scripts/fzf-git.sh"
source_if_exists "$HOME/.bun/_bun"
