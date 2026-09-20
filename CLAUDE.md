# Repository Guidelines

## Git

**Commit directly to `main`. Never create a branch.**

This overrides the default behaviour of branching before you commit on the
default branch.

- Do not create or switch branches unless I ask for one in that same message.
- Do not open pull requests.
- Commit to `main`, whatever the size of the change.

## Rebuild

**Apply changes yourself. Do not ask me to run the rebuild.**

`sudo nixos-rebuild` runs without a password on this machine. The sudoers
rule allows only `/run/current-system/sw/bin/nixos-rebuild`, so `sudo -n true`
fails; that does not mean the rebuild needs a password.

```
sudo nixos-rebuild switch --flake .#<hostname>
```
