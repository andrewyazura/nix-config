# Guidelines

**Tradeoff:** These guidelines bias toward caution and correctness. For trivial tasks, use judgment — not every one-liner needs a plan.

## 1. Think Before Coding

**Explore first. Surface tradeoffs. Don't hide confusion.**

- Read relevant code, trace call chains, check git history before proposing solutions
- State assumptions explicitly — if uncertain, ask
- If multiple approaches exist, present them with trade-offs; don't pick silently
- If something is unclear, stop — name what's confusing and ask
- After an approach is chosen, outline signatures and general logic, then implement without stopping to ask for permission — proceed through the natural sequence of work
- Use Context7 MCP proactively for library/API docs, code generation guidance, and framework conventions

## 2. Simplicity First

**Minimum code that solves the problem. Nothing speculative.**

- No features beyond what was asked
- No abstractions for single-use code — three similar lines is better than a premature helper
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios; trust internal code and framework guarantees
- Prefer pure functions, immutability, and composition over mutation and inheritance

Self-check: *Would a senior engineer say this is overcomplicated? If yes, simplify.*

## 3. Surgical Changes

**Touch only what you must. Fix at the right layer.**

- Make the smallest, most localized change — modify at the correct layer in the call hierarchy so all callers benefit
- Mirror established codebase conventions in naming, formatting, structure, and patterns — read surrounding code first
- Before writing new utilities or abstractions, search the codebase for existing ones — never reimplement what already exists
- Don't "improve" adjacent code, comments, or formatting that aren't part of the task
- Propagate context, aliases, and relevant parameters through all layers of abstraction (e.g., database connections, request context, configuration)
- Preserve backward compatibility unless explicitly asked to break it
- When modifying code, ensure the fix applies at the right abstraction level — not just the immediate call site but wherever the root cause lives

When your changes create orphans:
- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked — mention it instead

Self-check: *Every changed line should trace directly to the user's request.*

## 4. Code Quality

**Encode constraints in types. Validate at boundaries.**

- Make illegal states unrepresentable through types — not runtime checks
- Handle errors explicitly: use Result/Either patterns in typed languages, never silently swallow exceptions
- Validate at system boundaries (user input, external APIs, deserialization); trust internal code within those boundaries
- Ensure equality, hashing, and comparison operations consider all relevant attributes — prevent unintended collisions
- When handling serialization/deserialization, validate and sanitize input gracefully — handle corrupted or malformed data

## 5. Verification

**Define success criteria. Verify incrementally. Loop until confirmed.**

Transform tasks into verifiable goals:
- "Add validation" → "Write tests for invalid inputs, then make them pass"
- "Fix the bug" → "Write a test that reproduces it, then fix it"
- "Refactor X" → "Ensure tests pass before and after"

- Compile/build after each file change, run relevant tests after each logical unit — don't batch all verification to the end
- After implementation, use a subagent to review for edge cases and missed code paths
- Do not commit changes unless explicitly asked — summarize what was done and let the user decide
