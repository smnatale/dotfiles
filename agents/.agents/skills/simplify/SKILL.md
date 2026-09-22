---
name: simplify
description: Simplify and refine recently modified code for clarity and consistency. Use after writing code to improve readability without changing functionality.
---

Refine code proactively after writing or modifying it. Favor readable, explicit code over compact solutions, and preserve all existing features, outputs, side effects, and error behavior.

Only refine recently modified code unless the user explicitly requests a broader review. Leave unrelated work alone.

Follow applicable project instructions, including local `CLAUDE.md` and `AGENTS.md` files. Derive language and framework conventions from the project rather than imposing a particular style.

## Usage

```text
/simplify
/simplify focus on performance and memory usage
/simplify pay extra attention to React re-renders
```

Treat any text after `/simplify` as additional review focus. Include it in each review agent's task without replacing the core reviews or the requirement to preserve functionality.

## Workflow

1. Run `git diff` or `git diff HEAD` to identify changed files and inspect their changes. Use `git diff HEAD` when staged changes should be included. Check `git status --short` for newly added files that the diff may omit. If there are no changes, report that rather than expanding the scope.
2. Launch three parallel review agents against the same changes:
   - Code reuse: look for duplicated logic and existing helpers or abstractions that the changed code should reuse.
   - Code quality: look for unnecessary complexity, unclear names, redundant state, and weak separation of concerns.
   - Efficiency: look for unnecessary work, repeated computation or I/O, excessive allocation, retained resources, and avoidable updates.
3. Give each agent the changed code, relevant project instructions, and the user's additional focus. Agents may inspect surrounding code for context, but should return concrete findings and suggested fixes without editing files.
4. Aggregate the findings, remove duplicates, and check each suggestion against the actual code. Apply worthwhile fixes directly within the changed scope. Skip speculative optimizations and changes whose behavior cannot be preserved confidently.
5. Review the resulting diff and run relevant project checks. Summarize significant changes, verification results, and any limits to verification. If no refinements are warranted, say so.

If parallel agents are unavailable, perform the three reviews sequentially and disclose that limitation.

## Refinement criteria

Look for refinements that make the code easier to read and maintain:

- Reduce unnecessary complexity and nesting.
- Remove redundant code and abstractions that add no clarity.
- Choose clear variable and function names.
- Consolidate related logic without combining unrelated concerns.
- Remove comments that merely describe obvious code. Keep comments that explain non-obvious constraints or behavior.
- Avoid nested ternary operators. Use clear conditional branches for multiple conditions.

Keep useful abstractions and boundaries. Avoid clever rewrites, dense one-liners, or changes that make debugging and extension harder. Fewer lines are not a goal in themselves. Leave already-clear code alone.

Confirm that each refinement improves readability, consistency, reuse, or efficiency without changing functionality. Preserve error handling, evaluation order, and resource lifetimes where they affect behavior.
