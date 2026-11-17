---
description: Start a Claude Code Remote Control server for a project, in tmux
argument-hint: <project> [corp]
allowed-tools: Bash, AskUserQuestion
---

## Request

Start one Remote Control server for: **$ARGUMENTS**

The word `corp`, `work`, `company` or `team` in the request selects the
corporate account. Anything else selects the personal account.

## Live state

- Host: !`hostname`
- Servers now: !`tmux -L claude-rc list-panes -a -F "#{session_name} on-demand=#{?@on-demand,yes,no} #{pane_current_path}" 2>/dev/null || echo "no claude-rc tmux server running"`
- Candidate projects: !`{ ls -d ~/Documents/*/ /disk_alpha/stash/ 2>/dev/null; find ~/Documents -maxdepth 3 -name .git -type d 2>/dev/null | sed "s|/.git$|/|"; } | sort -u`

## Your task

You start the server and report back. The user then opens sessions on it from
the Claude app. The server runs in tmux on the `claude-rc` socket, next to the
permanent servers that the `claude-remote-control` service keeps alive. It
lasts until reboot or `/close-session`.

Do every step with the Bash tool.

### 1. Resolve the directory

Match the project name against the candidate list above.

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

If two directories match, ask the user which one. Do not guess. If nothing
matches, stop and tell the user.

### 2. Check for an existing server

The tmux session name is `<account>-<slug>`: `personal` or `corp`, then the
short project slug in lower case. Examples: `personal-bingo`, `corp-stash`.

If the server list above already has a session for this account and path,
permanent or on demand, stop and report it. Do not start a second one.

### 3. Launch

Personal account uses `claude`. Corporate account uses `claude-corp`.

```
env -i HOME="$HOME" USER="$USER" LOGNAME="$USER" TERM=xterm-256color LANG=en_US.UTF-8 \
  "$(command -v tmux)" -L claude-rc -f /dev/null new-session -d -s <name> -c <path> \
  "$(command -v zsh) -lc 'while true; do <claude|claude-corp> remote-control --permission-mode bypassPermissions --spawn same-dir; sleep 10; done'"
tmux -L claude-rc set-option -t '=<name>' @on-demand 1
```

`env -i` keeps this session's Claude variables out of a tmux server that the
command may have to start. The loop restarts the server if it exits after a
network outage.

### 4. Clear the start prompts

Wait 5 seconds, then read the pane. Never send keys blind:

```
tmux -L claude-rc capture-pane -p -t '=<name>'
```

- **"Enable Remote Control? (y/n)"**: send `y`, then `Enter`. Appears once per
  account.
- **Trust check**: appears once per directory. Accept it only for a path from
  the table above. For any other path, ask the user first: trusting a folder
  lets its `.mcp.json` servers and `.claude` hooks run. Read the options on
  screen and select the one that trusts the folder.

Send each key separately, about 1 second apart, and capture the pane again
after every answer. React to the screen you see, not to this list.

### 5. Verify

The server is ready when the pane shows `Connected` and a
`claude.ai/code?environment=env_...` URL.

If the pane shows an error, a login prompt or a bare shell prompt, the launch
failed. Report the pane contents. If the loop keeps failing, stop it with
`tmux -L claude-rc kill-session -t '=<name>'`. Do not retry.

### 6. Report

Two lines at most: the tmux session, the account, the path, and the
environment URL from the pane.

Example: "Started `personal-bingo`, personal account, `~/Documents/bingo` —
https://claude.ai/code?environment=env_01AbC..."

## Rules

- Start one server per request.
- Do not send a prompt or a task into the server or its sessions.
- Do not touch other tmux sessions.
- Do not edit files in the target project.
