---
name: split-pr
description: Split the current branch into a stack of smaller draft PRs using gh stack. Only run when the user types /split-pr.
disable-model-invocation: true
---

My current branch is never modified, checked out elsewhere, rebased or pushed. All work happens on new branches in a temporary worktree.

1. Work out the base branch. Read `git log` and the diff against it. If the working tree has uncommitted changes, tell me they won't be included and ask whether to carry on.
2. Propose the stack, bottom to top. For each slice give:
   - branch name: `<branch>-<n>-<slug>`, where slug is a short kebab-case name for what's in it
   - the commit message(s): keep my original messages where a commit moves over whole, otherwise write new ones in the same style (`git log --oneline -10`)
   - which files, or parts of files, go in it
   - each slice must pass lint, type checks, tests and CI with only the slices below it, so it can be merged on its own. Order slices so dependencies come first.
3. Wait for my ok.
4. Create a worktree in the scratchpad off the base branch. For each slice, branch off the previous slice (the first one off base), then:
   - cherry-pick whole commits that fit entirely in the slice
   - otherwise bring the changes over from my branch with `git checkout <branch> -- <file>` or by applying selected hunks, and commit
5. On each slice, run the repo's lint, type check and test commands (find them in `package.json`, `Justfile`, `Makefile`, `.github/workflows`). If a slice fails, move code between slices until it passes. Tell me about any change to the plan from step 2.
6. Check `git diff <branch> <top slice>` is empty. If it isn't, fix it before going further.
7. Trash the worktree. The branches stay.
8. Draft a PR for each slice the way `/pr` does: use the repo's PR template, lowercase plain title, simple description, no attribution. Mention it's part of a stack. Show me all of them with the branch each one targets.
9. Wait for my ok, then:
   - `git push -u origin <slice>` for each slice
   - `gh pr create --draft --base <previous slice or base> --head <slice>` for each, bottom to top
   - `gh stack link <slice-1> <slice-2> ...` to join them into a stack on GitHub
   - `gh stack init <slice-1> <slice-2> ...` to track the stack locally
10. Show me `gh stack view --short` and the PR links.
