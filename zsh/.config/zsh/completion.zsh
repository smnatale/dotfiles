load_completion_styles() {
	autoload -Uz compinit
	local compdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
	mkdir -p "${compdump:h}"

	if (( ! ${+_comps} )); then
		compinit -d "$compdump"
	fi

	zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
	if [[ -n ${LS_COLORS:-} ]]; then
		zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
	fi
}

load_completion_styles
