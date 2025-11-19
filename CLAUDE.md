# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a NixOS/nix-darwin flake-based configuration managing multiple machines:
- **NixOS hosts**: yorha2b (desktop), yorha9s (laptop), bunker, proxmoxnix
- **macOS host**: yorhaA2 (using nix-darwin)

The configuration uses flakes, home-manager for user environment management, and sops-nix for secrets management.

## Build and Deployment Commands

### Apply configuration on NixOS hosts
```bash
sudo nixos-rebuild switch --flake .#yorha2b
sudo nixos-rebuild switch --flake .#yorha9s
sudo nixos-rebuild switch --flake .#bunker
sudo nixos-rebuild switch --flake .#proxmoxnix
```

### Apply configuration on macOS (yorhaA2)
```bash
sudo darwin-rebuild switch
```

### Deploy to remote machines
```bash
nixos-rebuild --flake .#<machine> --target-host andrew@<machine> switch --sudo
```

### Garbage collection (run manually if needed)
```bash
# NixOS
nix-collect-garbage --delete-older-than 7d

# Check what will be deleted
nix-store --gc --print-dead
```

## Architecture

### Flake Structure (flake.nix)

The flake uses a `mkHost` helper function that:
1. Takes hostname, system architecture, specialArgs, and modules
2. Creates nixosSystem with home-manager and sops-nix integration
3. Passes `inputs` and `hostname` to all modules via specialArgs

**NixOS configurations**: Built with `nixpkgs.lib.nixosSystem`
**Darwin configurations**: Built with `nix-darwin.lib.darwinSystem`

### Directory Layout

```
├── flake.nix              # Main flake defining all host configurations
├── system/                # System-level NixOS modules (shared across hosts)
│   ├── audio/
│   ├── fonts/
│   ├── i3/
│   ├── sway/
│   ├── home-manager/      # Home-manager integration setup
│   ├── nix/               # Nix daemon and flakes configuration
│   └── programs/          # System-wide programs
├── darwin/                # macOS-specific system modules
│   └── aerospace/
├── home/                  # Home-manager modules (user environment)
│   ├── btop/
│   ├── ghostty/
│   ├── git/
│   ├── neovim/
│   ├── sway/
│   ├── waybar/
│   ├── zsh/
│   └── ...
├── hosts/                 # Per-host configurations
│   ├── yorha2b/
│   ├── yorha9s/
│   ├── yorhaA2/           # macOS host
│   ├── bunker/
│   └── proxmoxnix/
├── users/andrew/          # User-specific configurations
│   ├── system/            # System-level user settings
│   └── home/              # Home-manager user settings
└── secrets/               # sops-encrypted secrets
```

### Module System Pattern

All modules follow NixOS's module pattern using `lib.mkEnableOption` and `lib.mkIf`:

```nix
{ lib, config, ... }:
with lib;
let cfg = config.modules.modulename;
in {
  options.modules.modulename = { enable = mkEnableOption "description"; };
  config = mkIf cfg.enable { /* configuration */ };
}
```

Modules are enabled per-host in `hosts/<hostname>/default.nix`:
```nix
modules = {
  audio.enable = true;
  sway.enable = true;
  # ...
};
```

### Import Chain

**NixOS hosts**:
1. `flake.nix` → `mkHost` function
2. → `./system` (system-level modules)
3. → `./hosts/${hostname}` (host-specific config + hardware-configuration.nix)
4. → home-manager imports `./home` and user-specific configs from `./users/andrew/`

**macOS host (yorhaA2)**:
1. `flake.nix` → `nix-darwin.lib.darwinSystem`
2. → `./hosts/yorhaA2` (host config)
3. → `./darwin` (macOS system modules)
4. → home-manager imports `./home`

### Secrets Management (sops-nix)

Secrets are encrypted with age keys derived from SSH keys.

**Converting SSH keys to age**:
```bash
# Public key
ssh-to-age -i ~/.ssh/id_ed25519_yorhaXX_nixconfig_XXXX.pub

# Private key
ssh-to-age -i ~/.ssh/id_ed25519_yorhaXX_nixconfig_XXXX -private-key -o keys.txt
```

**Updating secrets after adding new hosts**:
1. Add public age key to `.sops.yaml`
2. Place private key in `~/.config/sops/age/keys.txt` on the target machine
3. Run: `sops updatekeys secrets/<secret_name>`

**Accessing secrets in modules**:
```nix
sops.secrets.secret-name = {
  sopsFile = ./secrets/secret-name;
  format = "binary";  # or "yaml", "json"
};

# Reference in config
config.sops.secrets.secret-name.path
```

### External Dependencies

- `inputs.private-config`: Private configuration repository (separate flake)
- `inputs.nixos-hardware`: Hardware-specific NixOS presets
- `inputs.ghostty`: Ghostty terminal emulator
- `inputs.nix-minecraft`: Minecraft server modules

## Common Workflows

### Adding a New Host

1. Create `hosts/<hostname>/default.nix` with configuration
2. Generate hardware config: `nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix`
3. Add to `flake.nix` outputs:
   ```nix
   nixosConfigurations.<hostname> = mkHost { hostname = "<hostname>"; };
   ```
4. Deploy: `sudo nixos-rebuild switch --flake .#<hostname>`

### Adding a New Module

1. Create module directory under `system/`, `darwin/`, or `home/`
2. Create `default.nix` with the module pattern (see above)
3. Add import to parent `default.nix`
4. Enable in host configs: `modules.<modulename>.enable = true;`

### Modifying Existing Configuration

When editing Nix files, note that changes to `system/` affect system-level config, while `home/` affects user environment. After editing, rebuild with appropriate command for the target host.
