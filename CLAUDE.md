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

# Deploy to bunker server (uses deploy-rs)
nix run github:serokell/deploy-rs -- .#bunker

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

**NixOS systems** use a `mkHost` helper in `flake.nix` (lines 76-95):
```nix
mkHost = { hostname, system ? "x86_64-linux", specialArgs ? {} }:
  nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs hostname; } // specialArgs;
    modules = [
      ./system                # Auto-imports ALL system modules
      ./hosts/${hostname}     # Host-specific config
      inputs.home-manager.nixosModules.home-manager
      inputs.sops-nix.nixosModules.sops
    ];
  };
```

**Darwin systems** use `mkDarwinHost` (lines 97-115):
- Similar pattern but does NOT auto-import `./system`
- Host config must manually import `../../darwin`

Configuration layers (both systems):
1. **Flake helper** - injects `inputs` and `hostname` as `specialArgs` to all modules
2. **Host config** (`hosts/<hostname>/default.nix`) - enables system/darwin modules
3. **Home-manager wiring** (inside host config):
   ```nix
   home-manager.users.andrew = {
     imports = [
       ../../home                         # All shared home modules
       ../../users/andrew/home            # User base config
       ../../users/andrew/home/yorha2b    # Host overrides (optional)
       inputs.private-config.homeManagerModules.default
     ];
     modules = { ... };  # Enable/configure modules
   };
   ```
4. **Private config** - additional modules via `private-config` flake input

### Module Pattern

All custom modules follow this structure:

```nix
{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.<module-name>;
in {
  options.modules.<module-name> = {
    enable = mkEnableOption "Description";
    # Optional: additional options with mkOption
  };

  config = mkIf cfg.enable {
    # Implementation
  };
}
```

Enable in configs: `modules.<module-name>.enable = true;`

**Module option customization** (when modules define extra options beyond `enable`):
```nix
# Example: Override ghostty font settings on macOS
modules.ghostty = {
  enable = true;
  backgroundOpacity = 0.9;    # Override default
  fontFamily = "SF Mono";     # Override default
  fontSize = 12;              # Override default
  fontStyle = "SemiBold";     # Override default
};
```

This pattern allows per-host customization without modifying the base module.

### SpecialArgs Flow (Advanced)

Understanding how `inputs` and `hostname` become available in all modules:

1. **Flake helpers inject specialArgs** (`flake.nix:84-87`):
   ```nix
   specialArgs = { inherit inputs hostname; } // specialArgs;
   ```
   This makes `inputs` and `hostname` available to ALL system-level modules.

2. **Home-manager receives extraSpecialArgs** (`system/home-manager/default.nix:6-8`):
   ```nix
   home-manager = {
     extraSpecialArgs = { inherit inputs hostname; };
   };
   ```
   This passes `inputs` (as a single attrset) and `hostname` into home-manager modules.

3. **Result**: Every module can access:
   - `inputs.<flake-name>` - reference any flake input
   - `hostname` - current machine name for conditional logic
   - Any module can use: `{ inputs, hostname, ... }: { ... }`

**Example use case** - Platform-specific package selection:
```nix
{ pkgs, hostname, ... }:
{
  home.packages = if hostname == "yorhaA2" then [ pkgs.darwin-specific ] else [ pkgs.linux-specific ];
}
```

### Secrets Access Control

Defined in `.sops.yaml` with per-machine age keys:
- `ssh-config` → personal machines (yorha2b, yorha9s, yorhaA2)
- `andrewyazura.{crt,key}` → bunker only

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

- **base** - Essential CLI tools without dedicated modules (age, fastfetch, git-lfs, htop, ncdu, ntfs3g, sops, tree, zip/unzip)
- **development** - Search and dev tools (ripgrep, fd, tree-sitter, vi-mongo)
- **media** - Media CLI tools (mpv)

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
- **development** - antigravity, intellij-idea, visual-studio-code
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
# yorhaA2
modules.packages = {
  media.enable = true;  # mpv
};
```

**Configured tools** (enabled separately via dedicated modules):
- git, neovim, tmux, zsh, direnv, btop, yazi, ghostty, ssh, firefox, claude, gemini, spotify

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

**Examples:** tree, ncdu, htop, ripgrep, fd, mpv, age, sops

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

**Minecraft Server** (`system/minecraft-server/`): Fabric 1.21.11 with sophisticated configuration pattern:
- Players in `players.nix`, mods in `mods.nix` with SHA512 verification via `fetchurl`
- Uses `mkOption` with `attrsOf submodule` for per-server configuration
- Demonstrates `recursiveUpdate` pattern for merging server templates with custom configs
- Dynamically generates firewall rules for TcpShield protection
- Imports external flake (`nix-minecraft`) as base infrastructure

**Claude Code** (`home/claude/`): This repo includes a home-manager module configuring Claude Code itself with permissions, hooks, and environment variables.

**Application Flakes**: Several custom applications are included as flake inputs and deployed on specific machines:
- `birthday-api-app`, `birthday-bot-app`, `stresses-bot-app`, `beast-music-app` - deployed on `bunker` server
- Applications are imported and configured in `hosts/bunker/apps/`

**Pattern for integrating external flake applications:**
1. Add flake input to `flake.nix`:
   ```nix
   inputs.my-app = { url = "github:user/my-app"; };
   ```
2. Create deployment config in `hosts/<hostname>/apps/my-app.nix`:
   ```nix
   { inputs, ... }: {
     imports = [ inputs.my-app.nixosModules.default ];
     # Configure the app module here
   }
   ```
3. Import in host config: `imports = [ ./apps/my-app.nix ];`

This pattern allows deploying external Nix-flake-based applications without vendoring code.

## Architectural Patterns

Key patterns used throughout this configuration:

**1. Module Aggregation** - Parent `default.nix` files import all submodules:
```nix
# system/default.nix, darwin/default.nix, home/default.nix
{
  imports = [
    ./submodule1
    ./submodule2
    # ... all submodules
  ];
}
```
This centralizes imports and allows auto-discovery of new modules.

**2. Enable Pattern** - Granular control via `mkEnableOption`:
- Every module has `modules.<name>.enable` option
- Host configs explicitly enable only needed modules
- Prevents "everything enabled by default" bloat

**3. Configuration Merging** - `recursiveUpdate` for combining configs:
```nix
# Merge base template with host-specific overrides
recursiveUpdate baseTemplate hostOverrides
```
Seen in: Minecraft server configs, module option overrides

**4. Platform Branching** - Conditional logic for cross-platform support:
```nix
package = if pkgs.stdenv.isDarwin then macPackage else linuxPackage;
```
Seen in: ghostty module, system vs darwin separation

**5. Helper Functions in Modules** - Reduce boilerplate:
```nix
# home/neovim/default.nix
let
  toLua = str: "lua << EOF\n${str}\nEOF";
  toLuaFile = path: toLua (builtins.readFile path);
in { ... }
```

**6. Secrets as File Paths** - sops-nix exposes secrets at runtime paths:
```nix
programs.ssh.includes = [ config.sops.secrets.ssh-config.path ];
```
Allows including binary files (certs, keys) without inline content.

**7. Per-Host SSH Key Naming** - Consistent naming convention:
```
id_ed25519_<hostname>_<service>_<date>
```
Examples: `id_ed25519_yorha2b_bunker_1801`, `id_ed25519_yorha9s_github_1510`

**8. Three-Layer Import Pattern** - Home-manager composition:
```nix
home-manager.users.andrew.imports = [
  ../../home                    # Shared modules (ALL)
  ../../users/andrew/home       # User base enables
  ../../users/andrew/home/HOST  # Host-specific overrides
];
```
Creates a pyramid: universal → user-level → host-level customization.
