---
paths:
  - "**/*.ts"
  - "**/*.tsx"
  - "**/*.js"
  - "**/*.jsx"
  - "tsconfig.json"
  - "package.json"
---

# TypeScript Conventions

## Type Safety
- Enable `strict: true` in `tsconfig.json` — never weaken with `any` casts
- Use `unknown` over `any` for truly untyped data; narrow with type guards
- Use discriminated unions (tagged unions) for state modeling over boolean flags
- Mark collections and parameters as `readonly` when mutation isn't needed
- Use `as const` for literal types and `satisfies` for type-safe inference

## Code Style
- Prefer `const` over `let`; never use `var`
- Use named exports over default exports for better refactoring and tree-shaking
- Use path aliases (configured in `tsconfig.json`) over deep relative imports (`../../../`)
- Prefer `async`/`await` over `.then()` chains for readability
- Use nullish coalescing (`??`) and optional chaining (`?.`) over manual null checks

## Error Handling
- Type errors explicitly: define error types or use discriminated result unions
- Never silently catch and ignore errors — log or rethrow with context
- Validate external data at system boundaries with Zod, io-ts, or similar runtime validators

## Testing
- Use the project's test runner (Jest, Vitest, or Node test runner)
- Use `describe`/`it` blocks; `describe` groups the unit, `it` describes the behavior
- Mock external dependencies at module boundaries, not internal functions

## React (when applicable)
- Prefer function components with hooks over class components
- Extract custom hooks for reusable stateful logic
- Use `React.memo` only after profiling — don't premature-optimize renders
- Keep components focused: if it has too many props, split it
