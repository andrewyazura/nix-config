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

# Format all Nix files
nix fmt                                   # Uses nixfmt

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

**NixOS systems** use a `mkHost` helper in `flake.nix` that:
- Takes hostname, system architecture, and optional modules
- Automatically imports `./system` and `./hosts/${hostname}`
- Injects `home-manager` and `sops-nix` modules
- Passes `inputs` and `hostname` as `specialArgs`

**Darwin systems** use `nix-darwin.lib.darwinSystem` directly without the helper.

Configuration layers (both systems):
1. **Host config** (`hosts/<hostname>/default.nix`) - imports system or darwin modules
2. **Shared modules** (`system/` or `darwin/`) - enabled via `modules.<name>.enable = true`
3. **Home-manager** - configured per-host, imports from:
   - `home/` - shared home-manager modules
   - `users/andrew/home/` - user-specific base config
   - `users/andrew/home/<hostname>/` - per-host user overrides (optional)
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

### NixOS
1. **Initial setup on new machine:**
   - Copy SSH keys to `~/.ssh` and set permissions: `chmod 700 ~/.ssh/ && chmod 600 ~/.ssh/* && chmod 644 ~/.ssh/*.pub`
   - Clone repo: `nix-shell -p git && git clone git@github.com:andrewyazura/nix-config.git`
   - Copy hardware config: `cp /etc/nixos/hardware-configuration.nix hosts/<hostname>/`
2. **Generate age key:** `ssh-to-age -i ~/.ssh/<key>.pub` (and private: `ssh-to-age -i ~/.ssh/<key> -private-key -o keys.txt`)
3. **Add key to secrets:** Add to `.sops.yaml` and run `sops updatekeys secrets/<secret-name>` for needed secrets
4. **Create host config:** `hosts/<hostname>/default.nix` following the module pattern
5. **Add to flake:** `nixosConfigurations.<hostname> = mkHost { hostname = "<hostname>"; };`
6. **Apply:** `sudo nixos-rebuild switch --flake .#<hostname>`

### macOS
1. Same SSH/clone setup as NixOS
2-3. Same age key and secrets setup
4. **Create host config:** `hosts/<hostname>/default.nix` using `darwinSystem` pattern (see `yorhaA2`)
5. **Add to flake:** `darwinConfigurations.<hostname> = nix-darwin.lib.darwinSystem { ... };`
6. **Apply:** `sudo darwin-rebuild switch --flake .`

## Package Management Architecture

Packages are organized into **purpose-based groups** rather than scattered across files:

### CLI Tools (Home-Manager Level)

Located in `home/packages/`, these are **cross-platform** command-line tools available on all machines:

- **base** - Essential CLI tools without dedicated modules (git-lfs, age, sops, tree, ncdu, htop, zip/unzip, ntfs3g)
- **development** - Fast search tools (ripgrep, fd, tree-sitter)
- **shell** - Shell enhancements (fastfetch)
- **media** - Media CLI tools (mpv)
- **ai** - AI tools (gemini-cli)

**Note:** Packages with dedicated config modules (git, neovim, tmux, zsh, direnv, btop, yazi, ghostty) are managed by their respective `home/<module>` modules, NOT in package groups. Package groups only contain tools without dedicated configuration.

### GUI Applications (System/Darwin Level)

Platform-specific graphical applications:

**NixOS** (`system/gui-apps/`):
- **base** - firefox, chromium, bitwarden-desktop, ghostty
- **communication** - discord, vesktop, signal-desktop
- **media** - spotify, obs-studio
- **productivity** - obsidian
- **gaming** - prismlauncher

**macOS** (`darwin/gui-apps/`):
- **base** - firefox, google-chrome, bitwarden, ghostty (Homebrew casks)
- **communication** - discord, slack, signal
- **gaming** - steam, prismlauncher
- **media** - spotify
- **productivity** - obsidian
- **system-tools** - focusrite-control-2, mos

**macOS System Packages** (`darwin/system-packages/`):
- **docker** - colima, docker, docker-compose (+ environment variables)
- **gnuTools** - coreutils-prefixed

### Package Configuration Hierarchy

Package enables follow the same pattern as other home-manager modules:

**Common packages** (`users/andrew/home/default.nix`):
```nix
modules.packages = {
  base.enable = true;        # git-lfs, age, sops, tree, ncdu, htop...
  development.enable = true;  # ripgrep, fd, tree-sitter
};
```

**Desktop-specific packages** (`users/andrew/home/<hostname>/`):
```nix
# yorha2b, yorha9s, yorhaA2
modules.packages = {
  shell.enable = true;  # fastfetch
  media.enable = true;  # mpv
  ai.enable = true;     # gemini-cli
};
```

**Configured tools** (enabled separately via dedicated modules):
- git, neovim, tmux, zsh, direnv, btop, yazi, ghostty, ssh, firefox

**Server machines** (bunker, proxmoxnix) automatically get base + development packages from common config.

### Host Configuration Examples

```nix
# Desktop system config (yorha2b, yorha9s)
# hosts/<hostname>/default.nix
modules.gui-apps = {
  base.enable = true;
  communication.enable = true;
  media.enable = true;
  productivity.enable = true;
  gaming.enable = true;  # Optional
};

# macOS system config (yorhaA2)
# hosts/yorhaA2/default.nix
modules = {
  gui-apps.base.enable = true;
  gui-apps.communication.enable = true;
  gui-apps.gaming.enable = true;
  # ... other gui-apps

  darwin-packages.docker.enable = true;
  darwin-packages.gnuTools.enable = true;
};

# Package enables are in users/andrew/home/, not host configs!
```

### Benefits

- **Consistency**: All machines get same CLI tools from home-manager
- **No Duplication**: Single source of truth per package
- **Granular Control**: Enable/disable entire categories
- **Cross-Platform**: macOS gets full CLI stack without platform-specific config

## Adding New Module

1. Create module in `system/`, `darwin/`, or `home/` using the module pattern above
2. Import in parent `default.nix`
3. Enable with `modules.<name>.enable = true;`

## Adding New Packages

**IMPORTANT:** Distinguish between plain packages and configured tools to avoid duplicate package errors.

### When to Use Package Groups

Add to `home/packages/<category>/` when the tool:
- Works out-of-the-box without configuration
- Has no dotfiles or settings to manage
- Is a standalone utility

**Examples:** tree, ncdu, htop, ripgrep, fd, mpv, age, sops, gemini-cli

```nix
# home/packages/base/default.nix
config = mkIf cfg.enable {
  home.packages = with pkgs; [
    tree
    ncdu
    htop
  ];
};
```

### When to Create a Dedicated Module

Create a module in `home/<name>/` when the tool:
- Requires configuration (dotfiles, settings, themes)
- You already manage its configuration
- Has a `programs.<name>` option in home-manager

**Examples:** git, neovim, tmux, zsh, direnv, btop, yazi, ghostty

```nix
# home/<name>/default.nix
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.<name>;
in {
  options.modules.<name> = {
    enable = mkEnableOption "Enable <name>";
  };

  config = mkIf cfg.enable {
    programs.<name> = {
      enable = true;
      # ... configuration
    };
  };
}
```

### Common Mistake to Avoid

**DON'T** add tools with dedicated modules to package groups:
```nix
# ❌ WRONG - This causes duplicate package errors
home.packages = with pkgs; [
  neovim  # Already installed via modules.neovim
  git     # Already installed via modules.git
];
```

**DO** enable their dedicated modules instead:
```nix
# ✅ CORRECT
modules = {
  neovim.enable = true;
  git.enable = true;
};
```

## Notable Configurations

**Neovim** (`home/neovim/`): Lua configs in `configs/` subdirectory. Uses treesitter, LSP (basedpyright, lua-language-server, nil, typescript-language-server), DAP debugging, and fzf-lua.

**Minecraft Server** (`system/minecraft-server/`): Fabric 1.21.11. Players in `players.nix`, mods in `mods.nix` with SHA512 verification via `fetchurl`.

**Claude Code** (`home/claude/`): This repo includes a home-manager module configuring Claude Code itself with permissions, hooks, and environment variables.

**Application Flakes**: Several custom applications are included as flake inputs and deployed on specific machines:
- `duty-reminder-app`, `birthday-api-app`, `birthday-bot-app` - deployed on `bunker` server
- Applications are imported and configured in host-specific configs
