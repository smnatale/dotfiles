# Global Agent Instructions

- Never commit to git
- Never use the em dash "—". Use plain dash "-" instead
- Never manually modify any files that are marked as auto-generated
- When making technical decisions, do not give much weight to development cost.
  Instead, prefer quality, simplicity, robustness, scalability, and long term maintainability.
- When fixing bugs, reproduce them in an E2E setting first, as close to the end-user experience as possible.
  This makes sure you find the real problem so your fix will actually solve it.
- When end-to-end testing a product, be picky about the UI you see and be obsessed with pixel perfection.
  If something clearly looks off, even if it is not directly related to what you are doing, try to get it fixed along the way.
- Apply that same high standard to engineering excellence: lint, test failures, and test flakiness.
  If you see one, even if it is not caused by what you are working on right now, still get it fixed.
- Ask before acting when: (1) the task is ambiguous, (2) there are multiple reasonable approaches,
  (3) changes span 5+ files, or (4) you would be modifying config, CI, or infrastructure files.
- When writing, reviewing, or refactoring code, apply the ponytail minimization heuristics (see ponytail skill).
- Be concise. Prefer direct answers. Do not add code explanation or summaries unless asked.
  Output no more than 3-4 lines of text before using tools.
- Always read a file before editing it. Never overwrite files without reading them first.
