---
name: spec
description: Interview the user about a feature until every decision is settled, then write SPEC.md for fresh agents to implement.
disable-model-invocation: true
---
# Spec

Produce a `SPEC.md` that a fresh agent can implement without stopping to ask. The implementing agent may decide what the global rules list (local names, private helper structure, which test cases to write) and what this spec leaves to it. Every other decision has to be settled here.

## 1. Gather evidence

Read the code, data and live systems the feature touches, at their latest version. Answer from evidence whatever you can, so the interview asks only what needs me.

## 2. Interview

- Ask in batches. For each question give the options, the one you'd pick, and why.
- Keep going until every section below is settled. Something I haven't answered is not settled, however obvious it seems.
- For each open choice, ask whether I'll decide it or leave it to the implementing agent.
- Push back when the feature, or a part of it, isn't worth building as asked.

## 3. Write SPEC.md

Ask me where to write it. Keep it as short as the feature allows, and don't restate code the agent can read.

- **Goal**: what changes, as behaviour someone could observe.
- **Go and place**: "Implement this now", the directory, the files the agent may touch, and the branch.
- **Settled decisions**: interfaces, names beyond local ones, data shapes, error behaviour, dependencies. Each gets the choice and one line of why.
- **Left to you**: the decisions I handed to the implementing agent, each with any limits I set.
- **Verification**: the exact commands, and the output that means done.
- **Commits**: whether the agent commits, and which paths.
- **Ownership**: when several agents run in parallel, which agent owns which files.
- **Left open**: anything I chose not to settle. The agent stops and asks about each one.
