#!/bin/bash
# PreToolUse guard for Bash: deny hard deletes (use trash), ask before history-destroying git,
# allow read-only `gh api` calls and ask for the rest.
# Backs up the permissions.deny rules, which only match a command's first word.
cmd=$(jq -r '.tool_input.command // empty')

# Start of a command: line start, after ; & | ( or $(, or after xargs/sudo/command/env.
start='(^|[;&|(]|\$\(|xargs([[:space:]]+-[^[:space:]]+)*|sudo|command|env)[[:space:]]*'
# End of a word.
end='([[:space:]]|$)'

decide() {
  jq -n --arg d "$1" --arg r "$2" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: $d, permissionDecisionReason: $r}}'
  exit 0
}

if grep -qE "${start}([^[:space:]]*/)?(rm|rmdir|unlink|shred)${end}" <<< "$cmd" \
  || grep -qE 'find[[:space:]].*-delete' <<< "$cmd"; then
  decide deny "Hard deletes are blocked. Use trash instead."
fi

# git subcommands that discard work or rewrite remote history. `args` is any flags/args before the match.
args='[[:space:]]+(.*[[:space:]])?'
destructive_git=(
  "clean[[:space:]]+-[a-zA-Z]*f"
  "reset${args}--hard"
  "push${args}(-f|--force[a-z-]*)${end}"
  "push${args}\+[^[:space:]]"
  "checkout${args}(--[[:space:]]+[^[:space:]]|\.${end}|-f${end}|--force${end})"
  "switch${args}(-f|--force|--discard-changes)${end}"
  "branch${args}(-[a-zA-Z]*D[a-zA-Z]*|--delete${args}(-f|--force)|(-f|--force)${args}(-d|--delete))${end}"
  "stash[[:space:]]+(drop|clear)${end}"
)
git_re="git[[:space:]]+(.*[[:space:]])?($(IFS='|'; echo "${destructive_git[*]}"))"

# `git restore` overwrites the working tree unless it only touches the index (--staged/-S without --worktree/-W).
restore_re="git[[:space:]]+(.*[[:space:]])?restore${end}"
if grep -qE "$git_re" <<< "$cmd" \
  || { grep -qE "$restore_re" <<< "$cmd" \
       && { ! grep -qE "[[:space:]](--staged|-[a-zA-Z]*S[a-zA-Z]*)${end}" <<< "$cmd" \
            || grep -qE "[[:space:]](--worktree|-[a-zA-Z]*W[a-zA-Z]*)${end}" <<< "$cmd"; }; }; then
  decide ask "This git command discards work or rewrites remote history."
fi

# gh api: allow a single GET call (optionally piped into jq), ask for anything else.
# gh switches to POST when fields or --input are passed, and graphql is always POST.
if grep -qE "${start}gh[[:space:]]+api${end}" <<< "$cmd"; then
  safe='[^;&|`$()<>]*'
  if [[ $cmd != *$'\n'* ]] \
    && grep -qE "^[[:space:]]*gh[[:space:]]+api[[:space:]]${safe}(\|[[:space:]]*jq[[:space:]]${safe})?$" <<< "$cmd" \
    && ! grep -qE "[[:space:]](-[fF]|--field|--raw-field|--input)"<<< "${cmd%%|*}" \
    && ! grep -qE "[[:space:]]graphql${end}" <<< "${cmd%%|*}" \
    && { ! grep -qE "[[:space:]](-X|--method)" <<< "${cmd%%|*}" \
         || grep -qE "[[:space:]](-X|--method)[[:space:]=]*[\"']?GET[\"']?${end}" <<< "${cmd%%|*}"; }; then
    decide allow "Read-only gh api call."
  fi
  decide ask "gh api call that may write."
fi
