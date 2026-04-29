source_if_exists() {
	[[ -r "$1" ]] && source "$1"
}

source_first_readable() {
	local candidate

	for candidate in "$@"; do
		if [[ -r "$candidate" ]]; then
			source "$candidate"
			return 0
		fi
	done

	return 1
}

source_homebrew_zsh_plugin() {
	local plugin_path="$1"

	source_first_readable \
		"/opt/homebrew/share/${plugin_path}" \
		"/usr/local/share/${plugin_path}"
}
