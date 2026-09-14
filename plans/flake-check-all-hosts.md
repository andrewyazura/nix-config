# Plan: evaluate every host before each commit

Status: implemented 2026-09-14. Not committed yet.

## Problem

CI evaluated `bunker` only. Nothing evaluated `yorha2b`, `yorha9s` or
`yorhaA2`. Commit `9bbb7cf` fixed a broken `yorhaA2` build that CI did not
catch.

## Success criteria

A commit that breaks any of the four host configurations fails before it
lands.

Regression test: the check must fail at revision `9bbb7cf~1` and pass at
`HEAD`.

## Design

The check runs in `.githooks/pre-commit`. CI keeps the bunker build and deploy
only.

- `.github/workflows/check.yml` is deleted. Formatting and host evaluation
  both move to the hook.
- `.github/workflows/deploy-bunker.yml` is untouched. It still evaluates,
  builds and deploys `bunker` on push to `main`.

## Findings

I validated these on 2026-09-14 from an `x86_64-linux` machine.

1. A Linux machine can evaluate the Darwin host. `nix eval --raw
   .#darwinConfigurations.yorhaA2.config.system.build.toplevel.drvPath`
   returns a `.drv` path. No macOS machine is necessary.
2. Evaluation is sufficient. No build is necessary. At `9bbb7cf~1` the same
   command fails with:

   ```
   error: Refusing to evaluate package 'kdenlive-26.08.0' ...
   because it is not available on the requested hostPlatform
   ```

3. **Bare `nix flake check` does not catch this.** At `9bbb7cf~1`,
   `nix flake check --all-systems --no-build` prints
   `checking flake output 'darwinConfigurations'...` and then reports
   `all checks passed!`. Nix enumerates `darwinConfigurations` but does not
   evaluate the configurations inside it. An explicit `checks` output is
   required.
4. All four hosts evaluate cleanly at `HEAD`.
5. **The hooks were never wired up.** `core.hooksPath` was unset and
   `.git/hooks/` held only samples, so the existing cs2 hook had never run.
6. Cost: 21s for all four hosts with a warm store, against 5s for the old
   bunker-only evaluation. One Nix invocation fetches inputs once. The extra
   time is mostly new input fetching — evaluating `yorha2b` and `yorha9s`
   reaches `hyprland`, `hy3`, `ghostty` and the zig overlay, which a
   bunker-only evaluation never touched.
7. On a dirty tree, Nix 2.34 reads the working tree and includes staged **and**
   untracked files.

## Steps

### 1. Add a `checks` output to `flake.nix`

Add this attribute beside `formatter`, inside the `outputs` attribute set:

```nix
      checks = {
        x86_64-linux = {
          yorha2b = self.nixosConfigurations.yorha2b.config.system.build.toplevel;
          yorha9s = self.nixosConfigurations.yorha9s.config.system.build.toplevel;
          bunker = self.nixosConfigurations.bunker.config.system.build.toplevel;
        };

        aarch64-darwin = {
          yorhaA2 = self.darwinConfigurations.yorhaA2.config.system.build.toplevel;
        };
      };
```

Verify: `nix flake check --all-systems --no-build` prints a
`checking derivation checks.<system>.<host>...` line for all four hosts and
then `all checks passed!`.

### 2. Extend `.githooks/pre-commit`

```sh
#!/bin/sh
set -e

if ! git diff --cached --quiet -- home/cs2/autoexec.cfg home/cs2/render_binds.py; then
  python3 home/cs2/render_binds.py home/cs2/autoexec.cfg > home/cs2/binds.svg
  git add home/cs2/binds.svg
fi

if git diff --cached --quiet -- '*.nix' flake.lock; then
  exit 0
fi

nix fmt -- --ci
nix flake check --all-systems --no-build
```

The git pathspec `'*.nix'` matches at any depth. I confirmed it selects all 99
tracked Nix files, 98 of which are nested.

`nix fmt` runs the flake's own `formatter`, which is `nixfmt-tree`. The old CI
command `nix shell nixpkgs#nixfmt -c nixfmt --check .` warned that passing a
directory "will be unsupported soon". The treefmt flag `--ci` implies
`--no-cache` and `--fail-on-change`.

Note that treefmt formats in place. On a misformatted file the hook rewrites
the file **and** exits 1, so the commit aborts with the fix already applied in
the working tree. Re-stage and commit again.

Verify: a commit that touches only Markdown skips both checks. A commit that
touches any `.nix` file runs them.

### 3. Wire up the hooks directory

```sh
git config core.hooksPath .githooks
chmod +x .githooks/pre-commit
```

This is local git config. It is not committed, so it has to be run once on
every clone. See Finding 5.

Verify: `git config core.hooksPath` prints `.githooks`.

### 4. Delete `.github/workflows/check.yml`

Leave `.github/workflows/deploy-bunker.yml` alone.

### 5. Regression-test the check

Do **not** run `nix flake check` directly against the old revision. The
`?rev=` form fetches the `flake.nix` of that revision, which has no `checks`
output yet. Finding 3 then applies and the command passes.

Use a probe flake instead. It pins the broken revision as an input and
supplies the `checks` output itself:

```sh
D=$(mktemp -d)
cat > "$D/flake.nix" <<EOF
{
  inputs.cfg.url = "git+file://$PWD?rev=$(git rev-parse 9bbb7cf~1)";
  outputs = { self, cfg }: {
    checks.aarch64-darwin.yorhaA2 = cfg.darwinConfigurations.yorhaA2.config.system.build.toplevel;
  };
}
EOF
(cd "$D" && nix flake check --all-systems --no-build)
```

Verify: the command fails with

```
error: Refusing to evaluate package 'kdenlive-26.08.0' ...
because it is not available on the requested hostPlatform
```

## Decisions

**List all four hosts, although `nix flake check` already walks
`nixosConfigurations`.** Finding 3 shows that the built-in walk is
inconsistent: it descends into `nixosConfigurations` but not into
`darwinConfigurations`. Do not depend on that behaviour. An explicit `checks`
output states what the hook guards in one place.

Nix walks the three NixOS hosts twice, once under `nixosConfigurations` and
again under `checks`. This costs nothing. It is one process, so the
evaluations are shared. Finding 6 confirms it: four hosts take about 21s, not
seven hosts' worth.

**Always pass `--no-build`.** The `checks` output holds four complete system
closures. A plain `nix flake check` tries to build all of them, and no Linux
machine can build the `aarch64-darwin` closure at all.

**Gate on `'*.nix'` and `flake.lock`.** Without the gate, every commit to a
Markdown file would pay the 21s. The existing cs2 step already used this
idiom.

## Known limits of a pre-commit hook

These are accepted, not solved.

- `git commit --no-verify` skips the hook.
- The hook only runs on the machine that commits. A commit made on `yorhaA2`
  without `core.hooksPath` set, or through the GitHub web UI, is unchecked.
- The hook reads the working tree, not the index (Finding 7). Staging a subset
  with `git add -p` validates something other than what gets committed.

## Out of scope

Three pre-existing issues surfaced during this work. Do not fix them here.

- `bunker` evaluates with a deprecation warning: `'system' has been renamed
  to/replaced by 'stdenv.hostPlatform.system'`.
- `bunker` builds as `nixos-system-nixos-...`, so `networking.hostName` looks
  unset for that host.
- `common/binary-cache/default.nix` trusts the key
  `main:3p3SLFLPh7NUwZ/1940Ez5F3DX/LmMOfJeWSoMaSgxI=`, but
  `deploy-bunker.yml` trusts `main:T8v5SdwjNhvJowlHJFFNB1O9PbXyLrZ+vRKe7OWGCa8=`
  for the same cache. One of the two is stale.
