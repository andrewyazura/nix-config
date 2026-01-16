# Project Overview

This is a Nix configuration repository for managing system and user configurations across multiple machines, including both NixOS (Linux) and macOS (via nix-darwin). It utilizes Nix Flakes for reproducible builds and dependency management.

The repository is structured to separate configurations for different concerns:

*   **`hosts/`**: Contains machine-specific configurations. Each host has its own directory.
*   **`system/`**: Contains system-level configurations that are shared across different Linux machines.
*   **`darwin/`**: Contains system-level configurations that are shared across different macOS machines.
*   **`home/`**: Contains user-level configurations (dotfiles, packages, etc.) managed by `home-manager`. These are largely shared across all machines.
*   **`users/`**: Contains user-specific configurations, which can be applied on top of the shared `home/` configuration.
*   **`secrets/`**: Manages secrets using `sops-nix`, with secrets encrypted and safe to be stored in the repository.

# Building and Running

The primary way to use this repository is to apply the configurations to a target machine. The commands vary slightly between NixOS and macOS.

## NixOS (Linux)

To apply the configuration to a NixOS machine defined in the `flake.nix` (e.g., `yorha2b`), run the following command on the target machine:

```bash
sudo nixos-rebuild switch --flake .#yorha2b
```

To build and apply the configuration to a remote NixOS machine:

```bash
nixos-rebuild --flake .#<machine> --target-host <user>@<machine> switch --sudo
```

## macOS (Darwin)

To apply the configuration to a macOS machine (e.g., `yorhaA2`):

```bash
darwin-rebuild switch --flake .#yorhaA2
```

# Development Conventions

*   **Modularity**: Configurations are broken down into smaller, reusable modules imported into the main host configurations.
*   **Secrets Management**: Secrets are managed with `sops-nix`. To edit a secret, use the `sops` command (e.g., `sops secrets/duty-reminder.env`). Public keys for encryption are defined in `.sops.yaml`.
*   **Formatting**: The code is formatted with `nixfmt`. You can format the entire repository by running `nix fmt`.
*   **Dependencies**: All external dependencies are managed as inputs in `flake.nix`.
