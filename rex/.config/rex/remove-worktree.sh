#!/bin/zsh
# Pick one of this repo's worktrees with fzf and remove it with wt, which also
# closes its Rex session. Run by the "Remove Worktree" palette action.
# zsh rather than sh so fzf picks up FZF_DEFAULT_OPTS from .zshenv.
set -eu

worktrees=$(wt list --format json) || { printf 'Not in a git repo. Press Return to close.'; read -r _; exit 0; }
# Run wt from the main checkout, so removing the worktree this pane is in works too.
main=$(jq -r '.items[] | select(.worktree.main) | .worktree.path' <<<"$worktrees")

branch=$(jq -r '.items[] | select(.worktree.main | not) | "\(.branch)\t\(.display.symbols)"' <<<"$worktrees" |
	fzf --prompt 'Remove worktree: ' --delimiter '\t' | cut -f1) || exit 0

# wt keeps unmerged branches, and refuses worktrees with uncommitted changes.
if ! wt -C "$main" remove --foreground "$branch"; then
	printf '\nRemove anyway, discarding uncommitted changes? [y/N] '
	read -r answer
	[[ $answer == [yY] ]] || exit 0
	wt -C "$main" remove --foreground --force "$branch"
fi
