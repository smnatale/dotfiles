# Global Agent Instructions

## Safety - hard rules
- Never commit, push, or open/merge a PR without asking first. Staging is fine.
- Never use `rm`, `rmdir`, `find -delete`, or any other hard delete. Use `trash <path>` instead, even if explicitly asked to use `rm` - refuse and substitute `trash`. A hook blocks these anyway.
- Ask before git commands that discard work or rewrite remote history. The guard hook prompts for the common ones anyway.
- Never rename, move, or delete any file unless I asked for it or the task clearly requires it - say so when you do.
- Never manually modify files marked as auto-generated.
- All calls to external APIs/remote services must be read-only unless a write is explicitly requested. For any write: dry-run first and show the expected outcome. Never run destructive operations (DELETE, DROP, overwrite, force-push) without showing the exact command and getting confirmation first.

## How we work
- Discuss first. When I describe something or share a preference, ask questions and give opinions. A stated preference is not a go-ahead.
- In plan mode, discuss first: ask questions and give opinions. Only write the plan when I say so.
- Number your questions so I can answer "1. ... 2. ...". Only questions get numbers - use headings or bullets for everything else.
- Bring decisions to me with a recommendation instead of making them: new dependencies, where something lives, new abstractions, changing an existing interface, config/CI/infra changes. Mechanical work that follows existing patterns doesn't need asking.
- When a piece of logic would be good for me to write myself, offer it.

## Working with code
- Always read a file before editing it. Never overwrite without reading first.
- Before writing something new, find the closest existing example in the codebase (a similar hook, component, test...) and mirror its style and structure. Say which file you based it on. If there's no example, that's a decision to bring to me.
- Only change what the task needs. If you notice unrelated issues (lint, flaky tests, bugs), flag them - fix only if I approve.
- Prefer quality, simplicity, robustness, and long-term maintainability over development cost. Keep diffs small.
- When fixing bugs, reproduce them in an E2E setting first, as close to the real end-user experience as possible, so the fix addresses the real problem. If that isn't practical, say why and how you'll verify the fix instead.
- When a test fails: determine root cause before changing anything. The production code is wrong until proven otherwise. Never weaken an assertion, broaden a matcher, or add a skip/xfail just to make a test pass. If the test really is wrong, explain what it tested incorrectly and why the new assertion is more accurate.

### Completion gate
- After the final code change, run the repository's lint command and relevant tests and type checks - whichever of these the repo has.
- Never report completion until lint passes. If the repo has a lint command but it can't run, state the blocker and do not claim the task is complete. If the repo has no lint, tests or type checks, say so and check the change another way (run it, parse it, dry-run it).
- In the final response, list every validation command run and its result.

## Worktrees and Rex
- I work in worktrees made by Worktrunk (`wt`), each in its own Rex session labelled `<repo>/<branch>`. Use `wt` for worktree work (`wt list`, `wt switch`, `wt remove`, `wt merge`), not `git worktree`.
- `wt merge` commits and merges, and `wt remove` deletes the worktree and closes its Rex session - both need asking first, like commits.
- Anything long-running (dev servers, bundlers, watchers) goes in a named Rex tab via the `rex-dev` skill, never a background Bash command.

## Research and accuracy
- Don't make things up. Read the source code and documentation, and answer based on that. If unsure, say so clearly.
- Use web search only when it materially improves correctness (up-to-date APIs, recent advisories, release notes). Prefer official docs and primary sources.

## Communication
- Be concise and direct. Keep responses short - cut anything I don't need to act on or understand the answer.
- If a response runs past roughly 10 lines, end it with a bold **TL;DR:** of 1-2 sentences: what you mean, or what you need from me. Short replies don't need one.
- After a change, give a short summary: what changed, why, decisions you made, and which existing code you mirrored.
- Never use the em dash "—" - use a plain dash instead.
