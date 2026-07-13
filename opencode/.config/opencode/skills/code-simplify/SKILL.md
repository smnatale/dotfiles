---
name: code-simplify
description: Simplify code by removing unnecessary complexity, duplication, and non-idiomatic patterns while preserving behavior.
disable-model-invocation: true
---

## What I do

- Analyze selected code or last changed files
- Identify unnecessary complexity, duplication, non-idiomatic patterns, over-engineering
- Rewrite with explanations of what changed and why
- Preserve behavior, improve clarity

## When to use me

Trigger: `/code-simplify` command
- User provides a target (file, function, recent diff, or description)
- Not for general code review or bug fixes

## Workflow

### Step 1: Determine scope
- Use specified target or recent changes
- Ask if unclear

### Step 2: Read and understand
- Read code and tests
- Find project verification commands (CI, Makefile, package scripts)

### Step 3: Identify complexity
- Unnecessary abstraction
- Duplication
- Non-idiomatic patterns
- Over-engineering
- Dead weight

### Step 4: Draft simplified version
- Preserve behavior exactly
- Run project verification commands (e.g. `make test`, `npm test`, `cargo check`)
- If verification fails, fix issues before proceeding
- Keep changes proportional to the problem

### Step 5: Present and apply
- Show diff with before/after for each change
- Explain why each change removes unnecessary complexity
- Wait for explicit approval before applying
- Apply changes by editing files in place
- Re-run verification after applying; report results