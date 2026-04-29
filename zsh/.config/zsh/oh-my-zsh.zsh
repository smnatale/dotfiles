load_oh_my_zsh() {
	export ZSH="$HOME/.oh-my-zsh"
	ZSH_THEME="robbyrussell"
	plugins=(git nvm)
	source "$ZSH/oh-my-zsh.sh"
}

if [[ -r "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]]; then
	load_oh_my_zsh
fi
