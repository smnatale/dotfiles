---
name: pr
description: Draft a pull request from the current branch using the repo's PR template. Only run when the user types /pr.
disable-model-invocation: true
---

1. Find the repo's PR template. Check `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE/`, `docs/` and the repo root (any case). If there isn't one, say so and use a plain summary instead.
2. Work out the base branch and read `git log` and the diff against it.
3. Fill in the template:
   - title: lowercase and plain, same style as commits
   - keep the description simple - enough context for a reviewer to know what changed, why, and which files to look at
   - don't explain every small detail; the diff covers that
   - no attribution
4. Show me the title and body, and which branch it targets.
5. Wait for my ok, then push the branch if needed and run `gh pr create`.
