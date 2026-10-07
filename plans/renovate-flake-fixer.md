# Plan: update flake inputs with Renovate, fix failures with Claude

Status: not started. Written 2026-10-07.

## Problem

Nothing updates the flake inputs on a schedule. On 2026-10-05, 10 of 22 inputs
had updates. The oldest locked input was 116 days old. `nix flake update` does
not move inputs pinned to a rev (hyprland, hyprland-plugins, attic).

## Success criteria

- Renovate opens one PR per outdated input, pinned revs included.
- Each new PR commit gets a `flake-fixer` status: all hosts evaluate and the
  Linux hosts build.
- On a failed PR, Claude either pushes a fix or writes a PR comment that tells
  why no update is possible. No issues are opened.

## Decisions

- Use Renovate, not Dependabot. Dependabot skips inputs pinned to a commit SHA
  and private inputs.
- Run Renovate self-hosted on bunker.
- The fix step is a separate service after Renovate, not a Renovate
  `postUpgradeTasks` command.
- The check evaluates and builds. It runs at 06:00, when nobody plays on the
  game servers.
- Claude runs in bypass permissions mode.

## Steps

1. **Secrets**
   - Make a fine-grained GitHub token for `nix-config`. It needs Contents,
     Pull requests and Commit statuses.
   - Make an SSH key that can read the 4 private inputs.
   - Add `.sops.yaml` rules and `sops.secrets` entries on bunker.
2. **Renovate on bunker**
   - Enable `services.renovate` with the repo, onboarding off and only the
     `nix` manager.
   - Group hyprland and hyprland-plugins in one PR.
   - Give it `nix` and `openssh`, the token and the SSH key.
   - Check the settings with `renovate-config-validator`.
3. **Check service**
   - Write a systemd oneshot service with a 06:00 timer that runs after
     Renovate.
   - List the open Renovate PRs and check each new head commit.
   - Show the result as a commit status on the PR.
4. **Claude session**
   - Make a separate user with no secrets.
   - Let the check service start Claude as that user, in tmux, with
     `--remote-control`.
   - Give Claude a fixed prompt. Find a way to know when Claude has finished,
     then close the session.
5. **Result**
   - Take Claude's changes, then commit and push them to the PR branch from
     the service's own clone.
   - Post Claude's summary as a PR comment.
6. **Rollout**
   - Add the secrets before the push, because a push to `main` deploys bunker.
   - After the deploy, log in to Claude as the new user and start a test run.

## Findings

These are the traps found on 2026-10-05.

1. The Renovate `nix` manager is beta and is off by default. The default
   `prHourlyLimit` is 2.
2. The NixOS Renovate unit is `Type=simple`, so `After=renovate.service` does
   not wait for Renovate to finish.
3. Renovate does not give its environment to child processes such as `nix`.
   Look at `customEnvVariables`.
4. `nix flake check --all-systems` evaluates all systems but builds only the
   local system.
5. Nix reuses a locked input from the store when the input is already there.
   So the Claude user does not need the SSH key if the check service fetched
   the inputs first.
6. Claude shows a trust dialog and a bypass warning at start. Both start on
   "No, exit". Claude still runs the prompt that is given as an argument after
   these dialogs. An interactive Claude session does not exit by itself.
7. Do not run git as a privileged user in a checkout that Claude controls.
   `.git/config` can run commands.
8. Renovate stops rebasing a branch after someone else commits to it. This
   keeps the fix.
