# Approach

- Explore and understand before proposing solutions — read relevant code, trace call chains, check git history
- Present multiple viable approaches with trade-offs before implementing; ask clarifying questions when requirements are ambiguous
- Use Context7 MCP proactively for library/API docs, code generation guidance, and framework conventions

# Code Modification Principles

- Make the smallest, most localized change that addresses the issue — modify at the correct layer in the call hierarchy so all callers benefit
- Mirror established codebase conventions in naming, formatting, structure, and patterns — read surrounding code first
- Reuse existing helpers, utilities, and abstractions in the codebase — never reimplement what already exists
- Propagate context, aliases, and relevant parameters through all layers of abstraction (e.g., database connections, request context, configuration)
- Preserve backward compatibility and consistency with existing behavior unless explicitly asked to break it
- When modifying code, ensure the fix applies at the right abstraction level — not just the immediate call site but wherever the root cause lives

# Code Quality

- Prefer pure functions, immutability, and composition over mutation and inheritance
- Make illegal states unrepresentable through types — encode constraints in the type system, not runtime checks
- Handle errors explicitly: use Result/Either patterns in typed languages, never silently swallow exceptions
- Validate at system boundaries (user input, external APIs, deserialization); trust internal code and framework guarantees
- Ensure equality, hashing, and comparison operations consider all relevant attributes — prevent unintended collisions
- When handling serialization/deserialization, validate and sanitize input gracefully — handle corrupted or malformed data

# Verification

- Always verify changes work: run tests, check types, execute the build — don't assume correctness
- When fixing a bug, write a failing test first that reproduces the issue, then fix it
- After implementation, use a subagent to review for edge cases and missed code paths
