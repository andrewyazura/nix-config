---
description: Close a Claude Code session running in tmux, found by project and account
argument-hint: <project> [corp]
allowed-tools: Bash, AskUserQuestion
---

## Request

Close the Claude Code session for: **$ARGUMENTS**

The word `corp`, `work`, `company` or `team` in the request selects the
corporate account. Anything else selects the personal account.

## Live state

- tmux panes: !`tmux list-panes -a -F "#{session_name}:#{window_index} #{window_name} #{window_id} #{pane_id} pane_pid=#{pane_pid} #{pane_current_path}" 2>/dev/null || echo "no tmux server running"`
- Live Claude sessions: !`for d in $HOME/.claude $HOME/.claude-corp; do a=personal; [ "$d" = "$HOME/.claude-corp" ] && a=corp; for f in $(find "$d/sessions" -maxdepth 1 -name '*.json' 2>/dev/null); do jq -c --arg account "$a" '{account: $account, pid, name, cwd, tmux, status}' "$f"; done; done`

## Your task

You close exactly one tmux window that holds a live Claude session. You never
guess which one. Do every step with the Bash tool.

### 1. Resolve the directory

Same table as `/new-session`:

| Spoken name | Path |
|---|---|
| nix, nix config | `~/Documents/nix/config` |
| nix private | `~/Documents/nix/private-config` |
| notes | `~/Documents/notes` |
| bass | `~/Documents/bass` |
| bingo | `~/Documents/bingo` |
| andrewyazura | `~/Documents/andrewyazura` |
| bombas | `~/Documents/bombas-resource-pack` |
| stash | `/disk_alpha/stash` |

If nothing matches, stop and tell the user.

### 2. Find the session record

Each line under "Live Claude sessions" is one running Claude. Keep the lines
whose account matches the request and whose `cwd` equals the project path.

- **0 lines**: there is no live Claude for that project and account. Stop and
  say so. A window may still hold a dead Claude or a bare shell. Do not touch
  it; tell the user about it instead.
- **1 line**: continue.
- **2 or more lines**: ask the user which one. Show each candidate's `name`,
  `tmux` field and `status`. Never pick.

### 3. Map the record to a window

The record's `tmux` field looks like `nix:@7.%9`. The `@7` part is the window
id; `%9` is the pane id. Find the pane line above with that same window id.
Target tmux by window id, never by `session:index`. Older records write the
session as a number (`0:@1.%1`); the window id still resolves.

### 4. Verify before you kill

Run both checks. Stop on any failure and report it. Do not kill.

1. The record's `pid` is alive: `ps -p <pid> -o pid=` prints it.
2. The process sits in that pane: `ps -o ppid= -p <pid>` equals the pane's
   `pane_pid`, or the pid itself is the `pane_pid`.
3. The process is a Claude: `ps -o args= -p <pid>` starts with `claude`.

A stale record from a crashed session must never kill whatever now sits in
that pane.

### 5. Check for work in progress

If the record's `status` is `idle`, continue. Any other value means the
session may be mid-task: `busy` is working, `waiting` is blocked on a prompt,
`shell` is in a shell. Ask the user before you kill it. Treat an unknown value
the same way.

### 6. Kill the window

The window id already carries its `@`:

```
tmux kill-window -t '@7'
```

Wait for the process to exit, up to 10 seconds:

```
for i in $(seq 10); do ps -p <pid> >/dev/null || break; sleep 1; done
```

Verify:

- `ps -p <pid>` no longer finds the process.
- `tmux list-panes -a` no longer lists the window id.

If the process survives, report it. Do not send `kill` to the pid unless the
user asks.

### 7. Report

Two lines at most: the window closed as `<session>:<name>`, the remote name,
the pid. If that was the last window, tmux dropped the session too; say so.

## Rules

- Close one window per request.
- Never run `tmux kill-session`.
- Never kill a window without a verified live record for it.
- Never kill a session whose `status` is not `idle` without asking.
