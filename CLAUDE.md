# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Nix flake-based configuration managing multiple NixOS systems and macOS using nix-darwin. Uses home-manager for user environments and sops-nix for encrypted secrets.

**Machines:**
- `yorha2b`, `yorha9s` - NixOS desktops (x86_64-linux)
- `bunker`, `proxmoxnix` - NixOS servers (x86_64-linux)
- `yorhaA2` - macOS (aarch64-darwin)

## Common Commands

```bash
# Build & apply locally
sudo nixos-rebuild switch --flake .#<hostname>   # NixOS
sudo darwin-rebuild switch --flake .              # macOS

# Build & apply remotely
nixos-rebuild --flake .#<hostname> --target-host andrew@<hostname> switch --sudo

# Test build without activating
nixos-rebuild build --flake .#<hostname>
darwin-rebuild build --flake .

# Flake management
nix flake update                          # Update all inputs
nix flake lock --update-input <input>     # Update specific input
nix flake show                            # Check outputs
```

### Secrets (sops-nix)

```bash
# Edit encrypted secret
sops secrets/<secret-name>

# Update keys after adding machine
sops updatekeys secrets/<secret-name>

# Convert SSH key to age format
ssh-to-age -i ~/.ssh/id_ed25519_<host>_nixconfig_<date>.pub
ssh-to-age -i ~/.ssh/id_ed25519_<host>_nixconfig_<date> -private-key -o keys.txt
```

Prerequisites: Public age key in `.sops.yaml`, private key in `~/.config/sops/age/keys.txt`

## Architecture

### Key Directories

| Directory | Purpose |
|-----------|---------|
| `hosts/<hostname>/` | Machine-specific configs (+ `hardware-config.nix` for NixOS) |
| `system/` | Shared NixOS modules (audio, networking, desktop environments) |
| `darwin/` | macOS-specific modules (Homebrew, AeroSpace, system defaults) |
| `home/` | Shared home-manager modules (git, zsh, neovim, ghostty, etc.) |
| `users/andrew/home/` | User-specific home configs; `default.nix` + per-host overrides |
| `common/` | Shared constants: `colors.nix` (Catppuccin), fonts, wallpapers |
| `secrets/` | Encrypted files managed by sops-nix |

### Configuration Flow

All configurations start from `flake.nix` which uses a `mkHost` helper for NixOS systems:

1. **Host config** (`hosts/<hostname>/default.nix`) - imports system or darwin modules
2. **Shared modules** (`system/` or `darwin/`) - enabled via `modules.<name>.enable = true`
3. **Home-manager** - configured per-host, imports from `home/` and `users/andrew/home/`
4. **Private config** - additional private modules via `private-config` flake input

### Module Pattern

All custom modules follow this structure:

```nix
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.<module-name>;
in {
  options.modules.<module-name> = {
    enable = mkEnableOption "Description";
  };

  config = mkIf cfg.enable {
    # Implementation
  };
}
```

Enable in configs: `modules.<module-name>.enable = true;`

### Secrets Access Control

Defined in `.sops.yaml` with per-machine age keys:
- `ssh-config` → personal machines (yorha2b, yorha9s, yorhaA2)
- `duty-reminder.env`, `andrewyazura.{crt,key}` → bunker only

## Adding New Machine

1. Create `hosts/<hostname>/default.nix` (+ `hardware-config.nix` for NixOS)
2. Generate age key: `ssh-to-age -i ~/.ssh/<key>.pub`
3. Add key to `.sops.yaml` and relevant `creation_rules`
4. Run `sops updatekeys secrets/<secret-name>` for needed secrets
5. Add to `flake.nix`: `nixosConfigurations.<hostname> = mkHost { hostname = "<hostname>"; };`

## Adding New Module

1. Create module in `system/`, `darwin/`, or `home/` using the module pattern above
2. Import in parent `default.nix`
3. Enable with `modules.<name>.enable = true;`

## Notable Configurations

**Neovim** (`home/neovim/`): Lua configs in `configs/` subdirectory. Uses treesitter, LSP (basedpyright, lua-language-server, nil, typescript-language-server), DAP debugging, and fzf-lua.

**Minecraft Server** (`system/minecraft-server/`): Fabric 1.21.11. Players in `players.nix`, mods in `mods.nix` with SHA512 verification via `fetchurl`.

**Claude Code** (`home/claude/`): This repo includes a home-manager module configuring Claude Code itself with permissions, hooks, and environment variables.
