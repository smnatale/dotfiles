#!/bin/bash
# PreToolUse guard for Bash: deny hard deletes (use trash), ask before history-destroying git.
# Backs up the permissions.deny rules, which only match a command's first word.
cmd=$(jq -r '.tool_input.command // empty')

# Start of a command: line start, after ; & | ( or $(, or after xargs/sudo/command/env.
start='(^|[;&|(]|\$\(|xargs([[:space:]]+-[^[:space:]]+)*|sudo|command|env)[[:space:]]*'

decide() {
  jq -n --arg d "$1" --arg r "$2" \
    '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: $d, permissionDecisionReason: $r}}'
  exit 0
}

if grep -qE "${start}([^[:space:]]*/)?(rm|rmdir|unlink|shred)([[:space:]]|$)" <<< "$cmd" \
  || grep -qE 'find[[:space:]].*-delete' <<< "$cmd"; then
  decide deny "Hard deletes are blocked. Use trash instead."
fi

if grep -qE 'git[[:space:]]+(.*[[:space:]])?(clean[[:space:]]+-[a-zA-Z]*f|reset[[:space:]]+(.*[[:space:]])?--hard|push[[:space:]]+(.*[[:space:]])?(-f|--force[a-z-]*)([[:space:]]|$)|checkout[[:space:]]+(.*[[:space:]])?--[[:space:]]+\.)' <<< "$cmd"; then
  decide ask "This git command discards work or rewrites remote history."
fi
