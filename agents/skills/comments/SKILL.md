---
name: comments
description: States the user's code comment preferences - short, single-line, and a signal to fix the code when a longer one feels needed. Use before writing or reviewing a code comment.
---

Default to no comments. A well-named identifier already says what the code does.

When a comment earns its place, it carries something the code can't: a non-obvious constraint, a subtle invariant, a workaround for a specific bug, or behavior that would surprise a reader.

Keep it to one line. If it wants to run longer or wrap, that's not a comment problem, it's the code underneath being too complex or badly named. Fix the code, not the comment:

- The name doesn't match what it does -> rename it.
- A block needs a paragraph to justify itself -> extract it into a well-named function and let the name carry the explanation.
- Several comments narrate a sequence of steps -> those steps belong in named helper calls, not prose.

Never write a comment that states what the code does, narrates the current task, or references a caller, fix, or ticket ("used by X", "added for the Y flow", "handles the case from #123"). That belongs in the commit message or PR description, not the source, and it rots the moment the code moves on.
