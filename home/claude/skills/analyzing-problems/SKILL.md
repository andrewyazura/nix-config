---
name: analyzing-problems
description: Structured deep analysis for complex problems requiring multi-perspective evaluation, trade-off analysis, and systematic decision-making. Activates when asked to analyze, evaluate, compare approaches, or make architectural/strategic decisions.
---

# Analyzing Problems

Systematic framework for problems that benefit from structured multi-perspective analysis.

## Perspectives

Evaluate the problem from each relevant perspective:

1. **Technical** — feasibility, scalability, maintainability, security, technical debt
2. **Business** — value, cost, time-to-market, risk/reward, competitive impact
3. **User** — needs, pain points, experience, edge cases, accessibility
4. **System** — integration points, dependencies, emergent behaviors, failure modes

## Reasoning Frameworks

Apply whichever are relevant:

- **First Principles** — decompose to fundamental truths, rebuild from there
- **Inversion** — what would guarantee failure? Avoid those things
- **Second-Order Effects** — consequences of consequences
- **Pre-mortem** — assume the decision failed; work backward to find why

## Output Structure

```
## Problem Analysis
- Core challenge and constraints
- Critical success factors

## Options
### Option N: [Name]
- Description
- Pros / Cons
- Implementation approach
- Risk assessment

## Recommendation
- Recommended approach with rationale
- Implementation roadmap
- Risk mitigation

## Open Questions
- Uncertainties and areas needing further investigation
```
