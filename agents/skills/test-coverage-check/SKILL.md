---
name: test-coverage-check
description: Add test coverage for new hooks, utilities, queries, and mutations without being asked, and state it explicitly before calling a task done. Use after writing any new hook, util, query, or mutation, and before reporting a task complete.
---

# Test coverage check

Before calling a task done, check whether you added a new hook, utility function, GraphQL query/mutation, or other unit with real logic. If so, add a test for it as part of the same change - don't wait to be asked.

If a test genuinely isn't practical (the only available test would need broad harness setup, brittle mocks, or slow e2e infra), say so explicitly and name what coverage exists instead (an E2E flow, a Maestro test, etc.) instead of silently skipping it.

State test coverage as part of finishing the task: what got tested, how, or why nothing was added.
