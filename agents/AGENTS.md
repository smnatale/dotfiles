# Global Agent Instructions

> This file records project conventions and common mistakes/confusion points agents hit in this codebase, so future agents don't repeat them. If something in the project surprises you, add a note here.

## Safety - hard rules
- Never commit to git.
- Never use `rm`, `rmdir`, or any other destructive delete. Use `trash` instead, even if explicitly asked to use `rm`/`rmdir` - refuse and substitute `trash`.
  - `rm <file>` -> `trash <file>`
  - `rm -rf <dir>` -> `trash <dir>`
  - `rmdir <dir>` -> `trash <dir>`
- Never manually modify files marked as auto-generated.
- All calls to external APIs/remote services must be read-only unless a write is explicitly requested. For any write: dry-run first and show the expected outcome. Never run destructive operations (DELETE, DROP, overwrite, force-push) without showing the exact command and getting confirmation first.

## Scope and approval
- Only modify files directly required by the current task. If a change would touch files outside that scope - including refactors, cleanup, or "improvements" - list the files and the reason, then wait for approval.
- Never rename, move, or delete any file without explicit instruction.
- Ask before acting when: (1) the task is ambiguous, (2) there are multiple reasonable approaches, (3) changes span 5+ files, or (4) you'd be modifying config, CI, or infrastructure files.

## Working with code
- Always read a file before editing it. Never overwrite without reading first.
- Prefer quality, simplicity, robustness, scalability, and long-term maintainability over development cost when making technical decisions.
- Apply minimization heuristics when writing, reviewing, or refactoring code.
- When fixing bugs, reproduce them in an E2E setting first, as close to the real end-user experience as possible, so the fix addresses the real problem.
- When a test fails: determine root cause before changing anything. The production code is wrong until proven otherwise. Never weaken an assertion, broaden a matcher, or add a skip/xfail just to make a test pass. If the test really is wrong, explain what it tested incorrectly and why the new assertion is more accurate.
- When end-to-end testing a UI, be picky and obsessed with pixel-perfection. If something looks off, even if unrelated to the current task, try to get it fixed along the way.
- Hold the same standard for engineering hygiene generally: fix lint errors, test failures, and flaky tests you encounter, even if unrelated to your current task.

### Mandatory completion gate
- After the final code change, run the repository's lint command and relevant tests and type checks.
- Never report completion until lint passes.
- In the final response, list every validation command run and its result.
- If lint cannot run, state the blocker and do not claim the task is complete.

## Research and accuracy
- Don't make things up. Read the source code and documentation, and answer based on that. If unsure, say so clearly.
- Use web search only when it materially improves correctness (up-to-date APIs, recent advisories, release notes). Prefer official docs and primary sources. Record source dates when relevant.

## Communication style
- Be concise. Prefer direct answers. No code explanations or summaries unless asked. Output no more than 3-4 lines of text before using tools.
- Never use the em dash "-" - use a plain dash instead.
