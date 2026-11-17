---
description: Stop an on-demand Claude Code Remote Control server, found by project and account
argument-hint: <project> [corp]
allowed-tools: Bash, AskUserQuestion
---

## Request

Stop the Remote Control server for: **$ARGUMENTS**

The word `corp`, `work`, `company` or `team` in the request selects the
corporate account. Anything else selects the personal account.

## Live state

- Servers: !`tmux -L claude-rc list-panes -a -F "#{session_name} on-demand=#{?@on-demand,yes,no} pane_pid=#{pane_pid} #{pane_current_path}" 2>/dev/null || echo "no claude-rc tmux server running"`

## Your task

You stop exactly one on-demand server that `/new-session` started. You never
guess which one. Do every step with the Bash tool.

### 1. Find the server

The tmux session name is `<account>-<slug>`: `personal` or `corp`, then the
short project slug, as `/new-session` names it. Match the request against the
server list above by account and project.

- **No match**: stop and say so.
- **Several matches**: ask the user which one. Never pick.
- **`on-demand=no`**: this is a permanent server. The `claude-remote-control`
  service recreates it within a minute, so stopping it is pointless. Stop and
  tell the user.

### 2. Check for sessions in progress

Read the pane:

```
tmux -L claude-rc capture-pane -p -t '=<name>:'
```

The `Capacity: N/32` line counts running sessions. If `N` is above 0, ask the
user before you stop the server: its sessions end with it.

### 3. Stop it

Send Ctrl-C first, so the server deregisters from claude.ai. A server killed
without it keeps the folder registered, and the next server there fails with
"This folder is already served".

The pane's loop restarts the server 10 seconds after it exits, so kill the
session 3 seconds after the Ctrl-C:

```
tmux -L claude-rc send-keys -t '=<name>:' C-c
sleep 3
tmux -L claude-rc kill-session -t '=<name>:'
```

Verify that `tmux -L claude-rc has-session -t '=<name>:'` fails and that no
`claude remote-control` process remains under the old `pane_pid`.

### 4. Report

One line: the session stopped, the account and the path.

## Rules

- Stop one server per request.
- Never run `tmux kill-server`.
- Never stop a permanent server.
