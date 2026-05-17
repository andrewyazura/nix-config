# Gemini Context: nix-config

This repository contains a modular Nix configuration using Flakes, NixOS, nix-darwin, and home-manager. It is designed to manage multiple machines (NixOS and macOS) with a shared core and machine-specific overrides.

## Project Overview

- **Core Technologies:** Nix (Flakes), NixOS, nix-darwin, home-manager.
- **Secret Management:** `sops-nix` with SSH/Age keys.
- **Disk Management:** `disko`.
- **Deployment:** `deploy-rs`.
- **Target Hosts:**
    - `yorha2b`, `yorha9s`: NixOS Desktop/Laptop.
    - `bunker`: NixOS Server.
    - `yorhaA2`: macOS (nix-darwin).

## Architecture

The project follows a highly modular structure:

- `flake.nix`: Entry point defining inputs and host configurations.
- `system/`: Global NixOS system modules (audio, networking, desktop environments, etc.).
- `darwin/`: Global nix-darwin modules.
- `home/`: Global home-manager modules (apps, shell, editor configs).
- `hosts/<hostname>/`: Host-specific configuration, hardware setup, and module enabling.
- `users/<username>/`: User-specific system and home-manager configurations.
- `common/`: Shared resources (colors, fonts, wallpapers, LLM guidelines).
- `secrets/`: Sops-encrypted files.

### Module Pattern

The project uses a custom `modules.<name>.enable` pattern for toggling features.
- Options are defined in `options.modules.<name>` within modules.
- Features are enabled/configured in `config = mkIf cfg.enable { ... }`.
- Profiles (in `system/profiles`) provide high-level bundles of modules (e.g., `desktop`, `development`, `gaming`).

## Building and Running

### Apply Configuration

- **NixOS:**
  ```bash
  sudo nixos-rebuild switch --flake .#<hostname>
  ```
- **macOS:**
  ```bash
  sudo darwin-rebuild switch --flake .#yorhaA2
  ```
- **Remote Deployment:**
  ```bash
  nix run github:serokell/deploy-rs -- .#<machine>
  ```

### Maintenance

- **Formatting:**
  ```bash
  nix fmt
  ```
- **Secrets:**
  To update keys for a secret after changing `.sops.yaml`:
  ```bash
  sops updatekeys secrets/<secret_name>
  ```

## Development Conventions

1. **Modular Design:** Always wrap new features in a module with a `modules.<name>.enable` option.
2. **Aggregators:** Add new modules to the `imports` list in the corresponding `default.nix` (e.g., `system/default.nix` or `home/default.nix`).
3. **Consistency:** Match existing style for Nix code (formatting, naming).
4. **Surgical Changes:** Only touch files relevant to the task. Avoid unrelated refactoring.

## LLM Guidelines (from common/llm-memory.md)

- **Think Before Coding:** State assumptions, surface tradeoffs, and ask for clarification if confused.
- **Simplicity First:** Write the minimum code necessary. Avoid speculative abstractions.
- **Surgical Changes:** Touch only what is required. Match existing style. Clean up your own orphans.
- **Goal-Driven Execution:** Define success criteria and verify changes (e.g., via `nix check` or dry-runs if possible).

## Key Files for Reference

- `flake.nix`: Main entry point.
- `hosts/yorha2b/default.nix`: Example of a full host configuration.
- `system/profiles/default.nix`: Definition of system profiles.
- `common/llm-memory.md`: Detailed LLM behavioral guidelines.
