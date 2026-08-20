---
name: self-verify-before-done
description: Run typecheck, lint, and tests on changed files as the last step before declaring a task complete - don't let the user be the one who discovers a broken build. Use before reporting any code change as finished.
---

# Self-verify before done

Before saying a task is complete, run the project's typecheck (`tsc`), lint, and any relevant tests against the files you changed. This is the last step of the task, not an optional follow-up.

Catching a broken build is your job. If `tsc`, lint, or a test fails because of your own change, fix it before reporting done - don't hand back a "done" that regresses to a failure the user then has to find and report back.
