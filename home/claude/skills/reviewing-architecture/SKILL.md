---
name: reviewing-architecture
description: Architecture review for codebases — analyzes structure, patterns, dependencies, data flow, scalability, and security. Activates when asked to review architecture, audit codebase structure, or assess technical design.
allowed-tools: Read, Glob, Grep, Bash
---

# Reviewing Architecture

Structured architecture review methodology.

## Before Analysis

Gather project context:
- Identify languages and project structure (look for package.json, requirements.txt, go.mod, Cargo.toml, build.gradle, flake.nix)
- Understand directory layout (top 2-3 levels)
- Gauge codebase size (file counts, line counts)
- Identify test patterns and documentation

## Analysis Framework

Evaluate each dimension. Skip dimensions that don't apply to the codebase.

1. **Component Structure** — module boundaries, layering, separation of concerns, directory organization
2. **Design Patterns** — patterns in use, consistency across codebase, anti-patterns present
3. **Dependency Architecture** — coupling between modules, circular dependencies, dependency direction, external dependency management
4. **Data Flow** — how data moves through the system, state management, persistence strategy, transformation chains
5. **Scalability & Performance** — bottleneck risks, caching strategy, resource management, concurrency model
6. **Security Boundaries** — trust boundaries, auth flow, input validation points, secret management

## Output Format

For each dimension reviewed, provide:
- **Current state** — what exists (with file:line references)
- **Issues found** — specific problems (with file:line references)
- **Recommended changes** — prioritized, with effort: low / medium / high

End with a summary table:

| Dimension | Health | Top Action Item |
|-----------|--------|-----------------|
| Component Structure | good / needs-work / critical | ... |
| Design Patterns | good / needs-work / critical | ... |
| Dependency Architecture | good / needs-work / critical | ... |
| Data Flow | good / needs-work / critical | ... |
| Scalability & Performance | good / needs-work / critical | ... |
| Security Boundaries | good / needs-work / critical | ... |
