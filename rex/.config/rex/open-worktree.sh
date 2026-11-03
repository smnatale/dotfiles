#!/bin/zsh
# Pick any worktree under ~/.worktrees with fzf and switch to its repo/branch
# session, creating the session first if it isn't open. Run by the "Open
# Worktree" palette action.
# zsh rather than sh so fzf picks up FZF_DEFAULT_OPTS from .zshenv.
set -eu

# Worktrees live at ~/.worktrees/<repo>/<sanitized branch> (see worktrunk's
# worktree-path), so read the real branch from git for the repo/branch label
# that "New Worktree" and wt's post-remove hook use.
worktrees=$(for dir in "$HOME"/.worktrees/*/*(N/); do
	branch=$(git -C "$dir" branch --show-current 2>/dev/null) || continue
	printf '%s/%s\t%s\n' "${dir:h:t}" "$branch" "$dir"
done)
[ -n "$worktrees" ] || { printf 'No worktrees in ~/.worktrees. Press Return to close.'; read -r _; exit 0; }

picked=$(sort <<<"$worktrees" | fzf --prompt 'Worktree: ' --delimiter '\t' --with-nth 1) || exit 0
label=${picked%%$'\t'*}
dir=${picked#*$'\t'}

session=$(rex ls --json | jq -r --arg label "$label" '[.sessions[] | select(.label == $label)][0].session_id // empty')
if [ -z "$session" ]; then
	session=$(rex new "$label" -c "$dir" --json | jq -r '.session_id')
fi

"$(dirname "$0")/select-session.sh" "$session" "$label"
