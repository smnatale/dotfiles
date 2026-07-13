---
name: review
description: Two-phase code review. Use when user says "review" or "code review".
disable-model-invocation: true
---

# Review

## Phase 1 - Feature Review

Analyze the recent changes and answer:

- What was actually achieved?
- Does it match the stated intent?
- Any bugs, edge cases, or missing logic?
- Any security concerns?
- Any performance issues?

Be specific. Reference file paths and line numbers.

## Phase 2 - Standards Review

Call the codebase-standards skill to check conventions against the changed code. Report any deviations or inconsistencies.

Output both reviews in sequence.