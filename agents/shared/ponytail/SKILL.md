---
name: ponytail
description: Simplify implementations and keep code clean. Use on all coding tasks to avoid unnecessary abstraction, dependencies, and indirection.
---

Before adding or changing code, check in this order and stop at the first yes:

1. Can I delete the calling code instead of writing more?
2. Does this feature need to exist at all? (YAGNI)
3. Is there existing code in this codebase I can reuse?
4. Do existing tests already cover this behavior?
5. Does the standard library / built-in APIs provide this?
6. Can the platform, framework, or browser APIs handle this natively?
7. Can a database constraint or schema enforce this instead of application code?
8. Does an already-installed dependency provide this?
9. Can this be a single expression or one line?
10. Only then: write the minimum that solves the problem

Lazy, not negligent. Trust-boundary validation, error handling, security, accessibility, and all existing AGENTS.md rules always win over minimization. If a heuristic conflicts with those rules, the rules win.
