---
name: debug
description: Structured debugging workflow for reproducing, isolating, and fixing bugs. Use when encountering errors, test failures, or unexpected behavior.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write
---

# Debug

Structured debugging workflow. Work through each phase sequentially — don't skip to a fix without understanding the root cause.

## Phase 1: Reproduce

- Get the exact error message, stack trace, or description of unexpected behavior
- Write a minimal reproduction: a test case, script, or sequence of commands that triggers the bug
- Confirm the reproduction fails consistently before proceeding

## Phase 2: Isolate

- Narrow the scope: which file, function, or line produces the incorrect behavior?
- Use binary search on the code path: add assertions or logging at midpoints to halve the search space
- Check recent changes: `git log --oneline -20` and `git diff HEAD~5` for relevant modifications
- Check git blame on the suspicious area to understand intent

## Phase 3: Root Cause

- Identify the **root** cause, not just the symptom — ask "why does this happen?" until you reach the fundamental issue
- Verify your hypothesis: predict what the code does with specific inputs and confirm
- Common root causes: wrong assumption about input, off-by-one, stale state, race condition, missing null check, incorrect operator precedence

## Phase 4: Fix

- Fix at the correct abstraction layer — if the root cause is in a shared utility, fix the utility, not every call site
- Write the smallest change that addresses the root cause
- Ensure the fix doesn't break the function's contract with its callers

## Phase 5: Verify

- Run the reproduction from Phase 1 — it should now pass
- Run the broader test suite to check for regressions
- If no test existed, write one that would have caught this bug

## Output

After fixing, provide a structured summary:

```
## Bug Report
- **Symptom**: What was observed
- **Root Cause**: Why it happened (file:line reference)
- **Fix**: What was changed and why
- **Tests**: What tests were added or updated
- **Related Risks**: Other code that might have the same issue
```
