---
name: commit
description: Commit changes with a message in my style.
disable-model-invocation: true
---

1. Run `git status` and `git diff --staged`. If nothing is staged, stage the changes yourself by path (`git add <paths>`), not `git add -A`. If there's nothing to commit, say so and stop.
2. If the staged changes cover unrelated things, suggest how to split them into separate commits and stop. If I reply "one", carry on with a single commit.
3. Run `git log --oneline -10` to match the existing style.
4. Write a message:
   - lowercase, plain and short, e.g. "added x w/ y"
   - no `feat:`/`chore:` style prefixes, no ticket numbers
   - no co-author or any other attribution
5. Run `git commit -m "<message>"`. The permission prompt is my confirmation.
