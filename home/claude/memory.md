# Approach

- Explore and understand before proposing solutions — read relevant code, trace call chains, check git history
- Present multiple viable approaches with trade-offs before implementing; ask clarifying questions when requirements are ambiguous
- After an approach is chosen, outline signatures and general logic, then implement without stopping to ask for permission or entering plan mode — proceed through the natural sequence of work
- Use Context7 MCP proactively for library/API docs, code generation guidance, and framework conventions

# Code Modification Principles

- Make the smallest, most localized change that addresses the issue — modify at the correct layer in the call hierarchy so all callers benefit
- Mirror established codebase conventions in naming, formatting, structure, and patterns — read surrounding code first
- Before writing new utilities, helpers, or abstractions, search the codebase for existing ones — never reimplement what already exists
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

- Verify incrementally: compile/build after each file change, run relevant tests after each logical unit of work — don't batch all verification to the end
- When fixing a bug, write a failing test first that reproduces the issue, then fix it
- After implementation, use a subagent to review for edge cases and missed code paths
- Do not commit changes unless explicitly asked — summarize what was done and let the user decide
