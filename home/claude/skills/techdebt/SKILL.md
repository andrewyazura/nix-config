---
name: techdebt
description: Scan recently changed files for tech debt — dead code, duplication, bloated abstractions, and stale comments. Run at the end of a session to catch agent-introduced bloat.
context: fork
allowed-tools: Read, Grep, Glob, Bash
---

# Tech Debt Cleanup

Scan files changed in this session for common tech debt patterns. Report findings without auto-fixing.

## What to Scan

Run `git diff --name-only HEAD` and `git diff --name-only --cached` to find changed files. If no commits were made this session, use `git diff --name-only` for unstaged changes.

## Patterns to Detect

1. **Dead code** — unused imports, unreachable branches, functions/variables that nothing calls
2. **Duplication** — copy-pasted logic that should be extracted (3+ similar lines)
3. **Bloated abstractions** — classes/functions doing too much, over-engineered patterns, unnecessary indirection
4. **Stale comments** — comments that no longer match the code they describe
5. **TODO/FIXME/HACK** — unresolved markers left behind
6. **Inconsistent naming** — new code that doesn't match the file's existing conventions

## Output

```
## Tech Debt Report

### <file>:<line> — <category>
<one-line description>
Suggestion: <how to fix>

---
Summary: X findings across Y files
```

If nothing found, say so. Do not invent problems.
