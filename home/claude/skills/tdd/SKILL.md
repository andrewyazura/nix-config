---
name: tdd
description: Test-driven development workflow. Write failing tests first, then implement the minimum code to make them pass. Use when implementing features or fixing bugs.
allowed-tools: Read, Grep, Glob, Bash, Edit, Write
---

# Test-Driven Development

Strict red-green-refactor cycle. Never write implementation before a failing test exists.

## Cycle

### 1. Red — Write a Failing Test

- Understand the requirement or bug to fix
- Write a test that asserts the expected behavior
- Run the test suite — confirm the new test **fails**
- If it passes, the behavior already exists or the test is wrong

### 2. Green — Minimum Implementation

- Write the smallest amount of code that makes the failing test pass
- Do not add extra logic, edge case handling, or "nice to have" behavior
- Run the test suite — confirm **all** tests pass (not just the new one)

### 3. Refactor — Clean Up (Only If Green)

- Only refactor when all tests are green
- Remove duplication introduced in the Green step
- Improve naming, extract methods — but change no behavior
- Run tests again after refactoring to confirm nothing broke

## Rules

- One test at a time. Do not batch-write tests
- Each cycle should be small — if a test requires 50+ lines of implementation, break the requirement into smaller pieces
- For bug fixes: write a test that reproduces the bug **before** touching any implementation code
- Use the project's existing test framework and conventions
- For Python: prefer `pytest`
- For Kotlin: prefer `JUnit 5` or whatever the project already uses

## Verification

After all cycles complete:
1. Run the full test suite
2. Confirm coverage of the new code (if coverage tooling is available)
3. List which tests were added and what they cover
