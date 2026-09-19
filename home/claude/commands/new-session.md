---
description: Start a Claude Code session for a project in tmux, with remote control
argument-hint: <project> [corp]
allowed-tools: Bash, AskUserQuestion
---

## Request

Start one Claude Code session for: **$ARGUMENTS**

The word `corp`, `work`, `company` or `team` in the request selects the
corporate account. Anything else selects the personal account.

## Live state

- Host: !`hostname`
- tmux now: !`tmux list-windows -a -F "#{session_name}:#{window_index} #{window_name} #{pane_current_path}" 2>/dev/null || echo "no tmux server running"`
- Candidate projects: !`{ ls -d ~/Documents/*/ /disk_alpha/stash/ 2>/dev/null; find ~/Documents -maxdepth 3 -name .git -type d 2>/dev/null | sed "s|/.git$|/|"; } | sort -u`

## Your task

You start the session and report back. The user attaches to tmux later, from
this machine or from a phone or tablet. So the session must run under tmux and
must use `--remote-control`.

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

### 2. Find or create the tmux session

One tmux session holds one project. The session name is the short project
slug, in lower case: `nix`, `stash`, `bass`.

Read the tmux list above.

- If the session exists, add a window to it:
  `tmux new-window -d -t <session> -c <path> -n <window>`
- If it does not exist, create it detached:
  `tmux new-session -d -s <session> -c <path> -n <window>`

Never attach. Never run `tmux attach`. The user attaches himself.

### 3. Name the window and the session

The window name is `claude` for the personal account, `claude-corp` for the
corporate account.

The `--name` value is `<host-prefix>-<project>`. Map the host:

| Hostname | Prefix |
|---|---|
| yorha2b | 2b |
| yorhaA2 | a2 |
| yorha9s | 9s |

If a window of that name already exists in the session, add a number. The
second personal Claude in `nix` gets window `claude-2` and `--name "2b-nix-2"`.

### 4. Launch

Personal account uses `claude`. Corporate account uses `claude-corp`, which is
the same binary with `CLAUDE_CONFIG_DIR=~/.claude-corp`. Both are allowed.

```
tmux send-keys -t <session>:<window> '<claude|claude-corp> --dangerously-skip-permissions --remote-control --name "<prefix>-<project>"' Enter
```

### 5. Clear the start dialogs

**Every dialog opens on "No, exit". A bare Enter closes Claude.** Send
`Down`, then `Enter`, for each one.

Wait 5 seconds, then read the screen. Never send keys blind:

```
tmux capture-pane -p -t <session>:<window>
```

Expect these screens:

1. **Trust check** — "Is this a project you created or one you trust?"
   Appears once per directory.
2. **Bypass permissions warning** — "WARNING: Claude Code running in Bypass
   Permissions mode". Appears on EVERY launch. It is never remembered, so
   always expect it.
3. **Remote control consent**, if it appears.

Send each key separately, about 1 second apart:

```
tmux send-keys -t <session>:<window> Down
tmux send-keys -t <session>:<window> Enter
```

Capture the pane again after every answer. The trust check does not come back
once accepted, so the set of screens differs between runs. React to the screen
you see, not to this list.

### 6. Verify

The session is ready when the status line shows `⏵⏵ bypass permissions on` and
the `❯` prompt is empty. The status line shows `/rc` when remote control is on.

If the pane shows an error, a login prompt or a bare shell prompt, the launch
failed. Report the pane contents. Do not retry in a loop.

### 7. Report

Give the user two lines at most: the tmux target `<session>:<window>`, the
remote name, the account, the path, and the `claude.ai/code/session_...` URL
that the ready pane prints. The user opens that URL on a phone or tablet.

Example: "Started `2b-nix-2` in `nix:claude-2`, personal account,
`~/Documents/nix/config` — https://claude.ai/code/session_01AbC..."

## Rules

- Start one session per request.
- Do not send a prompt or a task into the new Claude.
- Do not close tmux sessions or windows.
- Do not edit files in the target project.
