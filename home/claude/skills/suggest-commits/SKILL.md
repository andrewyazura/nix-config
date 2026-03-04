---
name: suggest-commits
description: Summarize uncommitted changes and suggest logical commit groupings with messages. Use before committing to plan clean, atomic commits.
allowed-tools: Bash, Read, Grep, Glob
---

# Suggest Commits

Analyze the current working tree and propose a commit plan with atomic, logical groupings.

## Process

1. Run `git status` and `git diff` (staged + unstaged) to understand all changes
2. Read changed files to understand the *purpose* of each change
3. Group related changes into logical commits — each commit should represent one coherent unit of work
4. For each group, suggest:
   - Which files to stage
   - A concise commit message (imperative mood, focus on *why*)

## Grouping Rules

- Separate refactors from behavior changes
- Separate test changes from implementation changes (unless TDD — then bundle test + impl)
- Config/dependency changes get their own commit
- Don't split a single logical change across commits just because it touches multiple files

## Output

```
## Commit Plan

### Commit 1: <message>
Files:
- path/to/file1
- path/to/file2
Rationale: <why these belong together>

### Commit 2: <message>
Files:
- path/to/file3
Rationale: <why these belong together>

---
Unstaged/untracked files not included: <list if any, with reason>
```

Do NOT run `git add` or `git commit`. Only analyze and suggest.
