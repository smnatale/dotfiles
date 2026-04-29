git_prompt_summary() {
	command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

	local branch git_status_text line
	local -i untracked=0 staged=0 modified=0 deleted=0 renamed=0 unmerged=0 ahead=0 behind=0
	local -a parts

	branch="$(git_current_branch 2>/dev/null)"
	git_status_text="$(command git status --porcelain=v1 --branch 2>/dev/null)" || return

	while IFS= read -r line; do
		case "$line" in
			'## '*)
				if [[ "$line" =~ 'ahead ([0-9]+)' ]]; then
					ahead=$match[1]
				fi
				if [[ "$line" =~ 'behind ([0-9]+)' ]]; then
					behind=$match[1]
				fi
				;;
			'?? '*)
				((untracked++))
				;;
			*)
				local x="${line[1]}"
				local y="${line[2]}"

				[[ "$x" != " " ]] && ((staged++))

				case "$y" in
					M) ((modified++)) ;;
					D) ((deleted++)) ;;
					R) ((renamed++)) ;;
					U) ((unmerged++)) ;;
				esac
				;;
		esac
	done <<< "$git_status_text"

	[[ -n "$branch" ]] && parts+=("$branch")
	(( staged )) && parts+=("*${staged}")
	(( untracked )) && parts+=("?${untracked}")
	(( modified )) && parts+=("~${modified}")
	(( deleted )) && parts+=("-${deleted}")
	(( renamed )) && parts+=("r${renamed}")
	(( unmerged )) && parts+=("!${unmerged}")
	(( ahead )) && parts+=("↑${ahead}")
	(( behind )) && parts+=("↓${behind}")

	(( ${#parts} )) || return
	print -r -- "${(j: :)parts}"
}

git_prompt_info() {
	local summary
	summary="$(git_prompt_summary)" || return
	local -a tokens details colored_details
	tokens=(${(s: :)summary})
	local branch="$tokens[1]"
	details=("${tokens[@]:1}")

	local token
	for token in "${details[@]}"; do
		case "$token" in
			\*[0-9]*) colored_details+=("%F{#f6c177}${token}%f") ;;
			\?[0-9]*) colored_details+=("%F{#9ccfd8}${token}%f") ;;
			\~[0-9]*) colored_details+=("%F{#eb6f92}${token}%f") ;;
			-[0-9]*) colored_details+=("%F{#eb6f92}${token}%f") ;;
			r[0-9]*) colored_details+=("%F{#c4a7e7}${token}%f") ;;
			\![0-9]*) colored_details+=("%F{#eb6f92}${token}%f") ;;
			↑[0-9]*) colored_details+=("%F{#908caa}${token}%f") ;;
			↓[0-9]*) colored_details+=("%F{#908caa}${token}%f") ;;
			*) colored_details+=("$token") ;;
		esac
	done

	print -r -- "%F{#9ccfd8} ${branch}%f${colored_details:+ ${=colored_details}}"
}

PROMPT=$'%F{#c4a7e7}%~%f $(git_prompt_info)\n%F{#eb6f92}❯%f '
RPROMPT=''
