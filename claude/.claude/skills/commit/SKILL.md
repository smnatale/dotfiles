---
name: commit
description: Commit the currently staged changes with a message in my style. Only run when the user types /commit.
disable-model-invocation: true
---

1. Run `git diff --staged`. If nothing is staged, say so and stop. Never stage files yourself.
2. If the staged changes cover unrelated things, suggest how to split them into separate commits and stop. If I reply "one", carry on with a single commit.
3. Run `git log --oneline -10` to match the existing style.
4. Propose a message:
   - lowercase, plain and short, e.g. "added x w/ y"
   - no `feat:`/`chore:` style prefixes, no ticket numbers
   - no co-author or any other attribution
5. Wait for my ok, then run `git commit -m "<message>"`.
