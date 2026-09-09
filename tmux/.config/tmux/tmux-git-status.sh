#!/usr/bin/env bash
set -euo pipefail

repo_path="${1:-}"
[ -d "$repo_path" ] || exit 0

repo_root=$(git -C "$repo_path" rev-parse --show-toplevel 2>/dev/null) || exit 0

branch=$(git -C "$repo_root" symbolic-ref --quiet --short HEAD 2>/dev/null || true)
if [ -z "$branch" ]; then
  branch=$(git -C "$repo_root" rev-parse --short=8 HEAD 2>/dev/null || true)
  [ -z "$branch" ] && exit 0
  branch="@$branch"
fi

staged=0
unstaged=0
untracked=0
conflicted=0

status=$(git -C "$repo_root" status --porcelain=v1 --untracked-files=normal 2>/dev/null || true)
while IFS= read -r line; do
  [ -z "$line" ] && continue
  index_state="${line:0:1}"
  worktree_state="${line:1:1}"

  if [ "$index_state" = "?" ] && [ "$worktree_state" = "?" ]; then
    untracked=$((untracked + 1))
    continue
  fi

  [ "$index_state" != " " ] && staged=$((staged + 1))
  [ "$worktree_state" != " " ] && unstaged=$((unstaged + 1))

  case "$index_state$worktree_state" in
    UU|AA|DD|AU|UA|DU|UD) conflicted=$((conflicted + 1)) ;;
  esac
done <<< "$status"

printf '#[fg=#9ccfd8]%s' "$branch"

upstream=$(git -C "$repo_root" rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || true)
if [ -n "$upstream" ]; then
  remote_branch="${upstream#*/}"
  [ "$remote_branch" != "$branch" ] && printf '#[fg=default]:%s' "$remote_branch"
  read -r behind ahead <<< "$(git -C "$repo_root" rev-list --left-right --count "$upstream...HEAD" 2>/dev/null || printf '0 0')"
  [ "${behind:-0}" -gt 0 ] && printf ' #[fg=#9ccfd8]⇣%s' "$behind"
  [ "${ahead:-0}" -gt 0 ] && printf ' #[fg=#9ccfd8]⇡%s' "$ahead"
fi

if git -C "$repo_root" rev-parse --verify refs/stash >/dev/null 2>&1; then
  stashes=$(git -C "$repo_root" rev-list --walk-reflogs --count refs/stash)
  [ "$stashes" -gt 0 ] && printf ' #[fg=#9ccfd8]*%s' "$stashes"
fi

[ "$conflicted" -gt 0 ] && printf ' #[fg=#eb6f92]~%s' "$conflicted"
[ "$staged" -gt 0 ] && printf ' #[fg=#f6c177]+%s' "$staged"
[ "$unstaged" -gt 0 ] && printf ' #[fg=#f6c177]!%s' "$unstaged"
[ "$untracked" -gt 0 ] && printf ' #[fg=#31748f]?%s' "$untracked"
