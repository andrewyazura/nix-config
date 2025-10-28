# NixOS Configuration Repository

## Project Overview

This repository contains a complete NixOS configuration managed using Nix Flakes. It declaratively manages the system-wide settings, user-specific configurations (via home-manager), and secrets (via sops-nix) for multiple machines (hosts). The configuration is highly modular, allowing for easy management and reuse of settings across different environments.

The core technologies used are:
- **NixOS:** A Linux distribution that uses a declarative model for system configuration.
- **Nix Flakes:** A feature of Nix that improves reproducibility and simplifies dependency management.
- **Home Manager:** A tool to manage a user's environment (`/home`) in a declarative and reproducible way.
- **sops-nix:** A tool for managing secrets securely within the NixOS configuration.

## Directory Structure

The repository is organized as follows:

- `flake.nix`: The central entry point for the Nix Flake, defining inputs (dependencies) and outputs (the system configurations).
- `system/`: Contains system-wide configuration modules that can be enabled on any host (e.g., audio, fonts, networking, programs).
- `home/`: Contains user-specific configuration modules managed by home-manager (e.g., shell, editor, git, and GUI application settings).
- `hosts/`: Contains host-specific configurations. Each subdirectory corresponds to a machine and defines which system and home modules to activate, as well as hardware-specific settings.
- `users/`: Contains user-specific settings, separating the base user configuration from machine-specific overrides.
- `secrets/`: Contains encrypted secret files managed by `sops`.

## Building and Running

To apply the configuration to a host, you use the `nixos-rebuild` command with the appropriate flake output. The general command is:

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Where `<hostname>` is one of the configurations defined in `flake.nix` (e.g., `yorha2b`, `yorha9s`, `bunker`).

For deploying to a remote machine, the command is slightly different, as shown in the `README.md`:

```bash
# Example for the 'bunker' host
nixos-rebuild --flake .#bunker --target-host andrew@bunker switch --sudo
```

## Development Conventions

- **Modularity:** Configurations are broken down into small, reusable modules located in the `system/` and `home/` directories.
- **Host-Specific Configuration:** Each machine has a dedicated file in the `hosts/` directory that composes the final system from the available modules.
- **Secrets Management:** Secrets are encrypted using `sops` and are decrypted at build time, ensuring they are not stored in plain text in the Nix store.
- **User Management:** User configurations are managed through `home-manager`, with a base configuration in `users/andrew/home` and machine-specific overrides in subdirectories like `users/andrew/home/yorha9s`.
