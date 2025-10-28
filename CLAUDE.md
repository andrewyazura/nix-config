# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configuration repository using Nix Flakes to manage multiple machines declaratively. It uses home-manager for user environment configuration and sops-nix for secrets management.

## Build and Deploy Commands

### Local Machine (yorha2b - main pc)
```bash
sudo nixos-rebuild switch --flake .#yorha2b
```

### Remote Hosts
```bash
# bunker server
nixos-rebuild --flake .#bunker --target-host andrew@bunker switch --sudo

# proxmoxnix VM
NIX_SSHOPTS="-i ~/.ssh/<key_name>" nixos-rebuild --flake .#proxmoxnix --target-host andrew@ip switch --sudo
```

### Other Available Hosts
- `yorha9s` - Laptop with ASUS Zephyrus hardware profile
- `yorha2b` - Main desktop
- `bunker` - Server hosting Minecraft, web services, and PostgreSQL
- `proxmoxnix` - Proxmox VM

## Architecture

### Flake Structure
The `flake.nix` defines a `mkHost` helper function that constructs NixOS configurations. Each host is created by specifying a hostname and optional hardware modules. The flake automatically imports:
- `./system` - System-wide configuration modules
- `./hosts/${hostname}` - Host-specific configuration
- home-manager and sops-nix modules

### Module System
All modules follow the NixOS module pattern with `options.modules.<name>.enable` options. Modules are conditionally activated using `mkIf cfg.enable` where `cfg = config.modules.<name>`.

**System modules** (`system/`): System-wide configuration enabled per-host
- `audio` - PipeWire audio stack
- `fonts` - System font configuration
- `gnome`, `i3`, `sway` - Desktop environment configurations
- `networking` - Network configuration
- `nix` - Nix daemon and flakes configuration
- `programs` - System-wide applications
- `minecraft-server` - Minecraft server with mod support
- `work` - Work-related tools (Cursor, Claude Code, VSCode, Zed, Pritunl VPN, Slack)
- `wooting` - Wooting keyboard support
- `guitar` - Guitar-related software

**Home modules** (`home/`): User-level configuration managed by home-manager
- `btop`, `firefox`, `ghostty`, `git`, `neovim`, `ssh`, `yazi`, `zsh` - Application configurations
- `gnome`, `i3`, `sway`, `polybar`, `waybar` - Desktop environment user configs

### Host Configuration Pattern
Each host in `hosts/<hostname>/default.nix`:
1. Imports `hardware-configuration.nix` and user configuration from `users/andrew/system`
2. Enables system modules via `modules.<module>.enable = true`
3. Configures home-manager imports and enables home modules
4. Sets host-specific hardware, boot, and system settings

Example:
```nix
modules = {
  audio.enable = true;
  sway.enable = true;
};

home-manager.users.andrew = {
  imports = [ ../../home ../../users/andrew/home ];
  modules = {
    sway.enable = true;
    waybar.enable = true;
  };
};
```

### User Configuration
User configurations are separated into system and home levels:
- `users/andrew/system/` - System-level user configuration (shell, groups)
- `users/andrew/home/` - Base home-manager configuration with common module enables
- `users/andrew/home/<hostname>/` - Host-specific home-manager overrides

### Secrets Management (sops-nix)
Secrets are encrypted using age and stored in `secrets/`. The `.sops.yaml` defines:
- Age keys for each host (yorha2b, yorha9s, bunker, proxmoxnix)
- Creation rules mapping secret files to hosts and formats (dotenv, binary)

To add a new secret:
1. Add the age public key to `.sops.yaml` under `keys`
2. Define a creation rule under `creation_rules` specifying the path pattern and authorized hosts
3. Encrypt the secret with `sops secrets/<filename>`
4. Reference in host config: `config.sops.secrets."<filename>".path`

The age key file location is specified per-host via `sops.age.keyFile` (typically `/var/lib/sops-nix/key.txt` for servers).

## Special Configurations

### Neovim Setup
The neovim module (`home/neovim/`) uses a custom pattern:
- Lua configurations are in `home/neovim/configs/`
- Helper functions `toLua` and `toLuaFile` embed Lua code
- Plugins are configured with inline Lua using `config = toLuaFile ./configs/<plugin>.lua`
- LSPs, formatters, and tree-sitter parsers are installed via `extraPackages`

### Minecraft Server (bunker)
The bunker host runs a Minecraft server using the nix-minecraft flake input:
- Server configuration in `system/minecraft-server/`
- Players defined in `players.nix`, mods in `mods.nix`
- Multiple servers supported via `servers.<name>` attribute set

### Custom Applications
The flake imports custom NixOS modules via flake inputs:
- `duty-reminder-app` - Duty reminder service
- `birthday-api-app` and `birthday-bot-app` - Birthday tracking services
These are enabled on the bunker host with service configurations.

## Common Patterns

### Adding a New Module
1. Create `<system|home>/<module>/default.nix`
2. Define `options.modules.<module>.enable = mkEnableOption "..."`
3. Add configuration in `config = mkIf cfg.enable { ... }`
4. Import in `<system|home>/default.nix`
5. Enable in host configuration via `modules.<module>.enable = true`

### Adding a New Host
1. Create `hosts/<hostname>/default.nix` and `hardware-configuration.nix`
2. Add host to `flake.nix` outputs: `<hostname> = mkHost { hostname = "<hostname>"; };`
3. Configure enabled modules and host-specific settings
4. For secrets: generate age key, add to `.sops.yaml`, configure `sops.age.keyFile`

### Testing Configuration Changes
Use `nixos-rebuild switch --flake .#<hostname>` to build and activate. For testing without activation, use `nixos-rebuild build --flake .#<hostname>`.

## References
- Heavily inspired by [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config/tree/i3-kickstarter)
- Hardware presets: [nixos/nixos-hardware](https://github.com/NixOS/nixos-hardware)
