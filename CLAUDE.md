# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS/nix-darwin configuration repository managing multiple machines using Nix flakes. It supports both Linux (NixOS) and macOS (nix-darwin) systems with a modular architecture.

### Managed Systems

**NixOS hosts:**
- `yorha2b` - Desktop workstation (x86_64-linux)
- `yorha9s` - ASUS Zephyrus laptop (x86_64-linux, uses nixos-hardware profile)
- `bunker` - Server (x86_64-linux)
- `proxmoxnix` - VM (x86_64-linux)

**Darwin host:**
- `yorhaA2` - macOS laptop (aarch64-darwin)

## Build Commands

### NixOS Systems

Apply configuration on local machine:
```bash
sudo nixos-rebuild switch --flake .#yorha2b
# or for other hosts: yorha9s, bunker, proxmoxnix
```

Apply configuration to remote machine:
```bash
nixos-rebuild --flake .#<hostname> --target-host andrew@<hostname> switch --sudo
```

### macOS (Darwin)

Apply configuration:
```bash
sudo darwin-rebuild switch
```

### Testing Configurations

Build without activating:
```bash
# NixOS
nixos-rebuild build --flake .#yorha2b

# Darwin
darwin-rebuild build --flake .
```

## Architecture

### Module System

The repository uses a custom module system with `modules.<name>.enable` options. Most modules are opt-in and must be explicitly enabled in host configurations.

**Structure:**
- `flake.nix` - Main entry point, defines all system configurations
- `hosts/<hostname>/` - Per-host configuration and hardware-configuration.nix
- `system/` - NixOS system-level modules (audio, networking, programs, etc.)
- `darwin/` - macOS system-level modules (aerospace, homebrew, system-defaults, etc.)
- `home/` - Home-manager modules (application configs for btop, firefox, ghostty, git, neovim, sway, waybar, zsh, etc.)
- `common/` - Shared configuration (colors.nix, fonts, nix settings, wallpapers)
- `users/andrew/` - User-specific configuration
- `secrets/` - sops-nix encrypted secrets

### Configuration Pattern

Host configurations (`hosts/<hostname>/default.nix`) follow this pattern:

```nix
{
  imports = [
    ./hardware-configuration.nix
    ../../users/andrew/system
    inputs.private-config.nixosModules.default  # or darwinModules for macOS
  ];

  modules = {
    # System modules
    audio.enable = true;
    fonts.enable = true;
    # ...
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
      ../../users/andrew/home/<hostname>
      inputs.private-config.homeManagerModules.default
    ];

    modules = {
      # Home-manager modules
      ghostty.enable = true;
      git.enable = true;
      # ...
    };
  };
}
```

### Flake Inputs

Key dependencies:
- `nixpkgs` - nixos-unstable channel
- `home-manager` - User environment management
- `sops-nix` - Secrets management
- `nix-darwin` - macOS system configuration
- `nixos-hardware` - Hardware-specific presets (used by yorha9s)
- `ghostty` - Terminal emulator
- `private-config` - Private configuration in separate repository

## Secrets Management (sops-nix)

Configuration is in `.sops.yaml` with age keys for each host.

### Converting SSH keys to age format:
```bash
# Public key
ssh-to-age -i ~/.ssh/id_ed25519_yorhaXX_nixconfig_XXXX.pub

# Private key
ssh-to-age -i ~/.ssh/id_ed25519_yorhaXX_nixconfig_XXXX -private-key -o keys.txt
```

### Updating secrets:

Ensure:
1. Public key is in `.sops.yaml`
2. Private key is in `~/.config/sops/age/keys.txt`

Then:
```bash
sops updatekeys secrets/<secret_name>
```

### Editing secrets:
```bash
sops secrets/<secret_name>
```

## Initial Setup Notes

For new NixOS installations (yorha2b, yorha9s):

1. Copy SSH keys to `~/.ssh` with correct permissions:
```bash
chmod -R 700 ~/.ssh/
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub
```

2. Clone repository:
```bash
nix-shell -p git
git clone git@github.com:andrewyazura/nix-config.git
```

3. Copy hardware-configuration.nix from new system:
```bash
# Generated hardware config is at /etc/nixos/hardware-configuration.nix
# Copy to hosts/<hostname>/hardware-configuration.nix
```

## File Path Conventions

- When referencing imports: Use relative paths from the importing file
- Module imports in `default.nix` files use directory names (e.g., `./audio` imports `./audio/default.nix`)
- System modules: `system/<module>/default.nix`
- Home modules: `home/<module>/default.nix`
- Darwin modules: `darwin/<module>/default.nix`

## Development Notes

- Nix flakes and experimental features are enabled globally
- AllowUnfree packages are enabled
- Garbage collection runs automatically (weekly on NixOS, see common/nix/default.nix)
- Configuration uses nixos-unstable for latest packages
