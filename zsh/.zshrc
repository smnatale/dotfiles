if [[ ${FIND_IT_FASTER_ACTIVE:-0} -eq 1 ]]; then
	bash
else
	# install zinit plugins manager
	ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

	# install if doesn't exist
	if [ ! -d "$ZINIT_HOME" ]; then
		mkdir -p "$(dirname "$ZINIT_HOME")"
		git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
	fi

	# source/load zinit
	source "${ZINIT_HOME}/zinit.zsh"

	# zsh plugins (optimized loading)
	zinit wait lucid for \
	    zsh-users/zsh-syntax-highlighting \
	    zsh-users/zsh-autosuggestions

	# keybindings
	bindkey "^[[B" history-search-forward
	bindkey "^[[A" history-search-backward

	# history
	HISTSIZE=5000
	HISTFILE=~/.zsh_history
	SAVEHIST=$HISTSIZE
	HISTDUP=erase
	setopt appendhistory
	setopt sharehistory
	setopt hist_ignore_space
	setopt hist_ignore_all_dups
	setopt hist_save_no_dups
	setopt hist_ignore_dups
	setopt hist_find_no_dups

	# completion styling
	_compinit_lazy() {
		if [[ -n "${_COMPINIT_LAZY_LOADED:-}" ]]; then
			return
		fi

		typeset -g _COMPINIT_LAZY_LOADED=1

		zinit light-mode for \
		    zsh-users/zsh-completions

		ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
		mkdir -p "${ZSH_COMPDUMP:h}"
		autoload -Uz compinit
		compinit -C -d "$ZSH_COMPDUMP"
		zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
		zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
	}

	_compinit_lazy_complete() {
		_compinit_lazy
		zle .expand-or-complete
	}
	zle -N _compinit_lazy_complete
	bindkey '^I' _compinit_lazy_complete

	# aliases
	alias ls='ls --color'
	alias n='nvim '
	alias tms='tmux-sessionizer'
	alias lg='lazygit'

	# executable files
	export PATH="$HOME/.local/bin:$PATH"

	# setup golang devtools
	export GOPATH=$HOME/go
	export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin

	# setup dev tools for react native
	export ANDROID_HOME=$HOME/Library/Android/sdk
	export PATH=$PATH:$ANDROID_HOME/emulator
	export PATH=$PATH:$ANDROID_HOME/tools
	export PATH=$PATH:$ANDROID_HOME/tools/bin
	export PATH=$PATH:$ANDROID_HOME/platform-tools
	export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

	export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"

	# opencode
	export PATH="/Users/samuelnatale/.opencode/bin:$PATH"

	# bun completions
	[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

	# bun
	export BUN_INSTALL="$HOME/.bun"
	export PATH="$BUN_INSTALL/bin:$PATH"

	export NODE_PATH=/usr/local/lib/node_modules

	export NVM_DIR="$HOME/.nvm"

	# Lazy-load nvm and related node tools on first use.
	_nvm_lazy_load() {
		if [[ -n "${_NVM_LAZY_LOADED:-}" ]]; then
			return
		fi

		typeset -g _NVM_LAZY_LOADED=1
		unfunction nvm node npm npx corepack 2>/dev/null

		[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
		[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
	}

	nvm() {
		_nvm_lazy_load
		nvm "$@"
	}

	node() {
		_nvm_lazy_load
		command node "$@"
	}

	npm() {
		_nvm_lazy_load
		command npm "$@"
	}

	npx() {
		_nvm_lazy_load
		command npx "$@"
	}

	corepack() {
		_nvm_lazy_load
		command corepack "$@"
	}

	# Oh My Posh prompt
	if (( $+commands[oh-my-posh] )); then
		omp_config="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh/rosepine.omp.toml"
		if [[ ! -f "$omp_config" ]]; then
			for candidate in \
				"$HOME/Projects/personal/dotfiles/zsh/.config/oh-my-posh/rosepine.omp.toml" \
				"$HOME/dotfiles/zsh/.config/oh-my-posh/rosepine.omp.toml"
			do
				if [[ -f "$candidate" ]]; then
					omp_config="$candidate"
					break
				fi
			done
		fi
		eval "$(oh-my-posh init zsh --config "$omp_config")"
	fi

	# Add a blank line before each prompt.
	autoload -Uz add-zsh-hook
	typeset -g _prompt_gap_seen=0
	typeset -g _prompt_gap_skip_next=0
	_prompt_gap_preexec() {
		case "$1" in
			clear|command\ clear)
				_prompt_gap_skip_next=1
				;;
		esac
	}
	_prompt_gap() {
		if (( _prompt_gap_skip_next )); then
			_prompt_gap_skip_next=0
		elif (( _prompt_gap_seen )); then
			print
		else
			_prompt_gap_seen=1
		fi
	}
	add-zsh-hook preexec _prompt_gap_preexec
	add-zsh-hook precmd _prompt_gap

fi
