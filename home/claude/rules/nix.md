---
paths:
  - "**/*.nix"
  - "flake.nix"
  - "flake.lock"
---

# Nix Conventions

## Module Pattern
- All modules follow `options.modules.<name>.enable = mkEnableOption "...";` with `config = mkIf cfg.enable { ... };`
- Use `mkDefault` in profiles so individual overrides (priority 100) beat profile defaults (priority 1000)
- Import submodules in parent `default.nix` in alphabetical order

## Formatting
- Use `nixfmt` (the official formatter) — run `nix fmt` before committing
- The CI runs `nixfmt --check` on all `.nix` files

## Best Practices
- Use `lib.getExe pkgs.foo` over `"${pkgs.foo}/bin/foo"` for binary paths
- Use `lib.mkIf`, `lib.mkMerge`, `lib.optionalAttrs`, `lib.optionals` for conditional config
- Prefer `pkgs.writeShellScript` or `pkgs.writeShellApplication` over inline bash strings
- Access sops-nix secrets via file paths: `config.sops.secrets.<name>.path` — never inline secret values
- Use `with lib;` at module top level for concise access to `mkIf`, `mkEnableOption`, etc.

## Flake Hygiene
- Pin inputs in `flake.lock`; update specific inputs with `nix flake lock --update-input <name>`
- Use `specialArgs` to pass `inputs` and `hostname` through to all modules
- Test builds with `nixos-rebuild build --flake .#<host>` or `darwin-rebuild build --flake .` before applying

## Common Pitfalls
- Don't add packages with dedicated modules (git, neovim, tmux) to package groups — enable their module instead
- Don't use `import <nixpkgs>` (impure) — always use flake inputs
- Don't use `nix-env` — all packages are declarative via modules
