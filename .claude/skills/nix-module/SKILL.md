---
name: nix-module
description: Generate new Nix configuration modules following this repository's standard pattern. Creates boilerplate in system/, darwin/, or home/ directories with proper options, then auto-imports into the parent default.nix.
argument-hint: [description of the module to create]
---

# Nix Module Generator

Create a new Nix module based on the user's request: $ARGUMENTS

## Workflow

1. **Parse the request** — determine from `$ARGUMENTS`:
   - **Module type**: `system/` (NixOS), `darwin/` (macOS), or `home/` (cross-platform home-manager)
   - **Module name**: kebab-case (e.g., `audio-pro`, `rectangle`, `alacritty`)
   - **Whether additional options** beyond `enable` are needed

2. **Ask clarifying questions** if the type or name is ambiguous. Prefer `home/` for user-level tools, `system/` for NixOS services, `darwin/` for macOS-specific config.

3. **Read the parent `default.nix`** for the chosen type to see existing imports:
   - `home/default.nix`
   - `system/default.nix`
   - `darwin/default.nix`

4. **Create the module file** at `<type>/<name>/default.nix` using the template below.

5. **Add the import** `./<name>` to the parent `default.nix`, maintaining alphabetical order.

6. **Report next steps** — where to enable the module and how to test.

## Module Template

Every module in this repo follows this exact structure:

```nix
{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.<name>;
in
{
  options.modules.<name> = {
    enable = mkEnableOption "Enable <name> configuration";
  };

  config = mkIf cfg.enable {
    # Implementation
  };
}
```

### Adding custom options

Only add options for values that **vary per host** (fonts, display settings, ports). Use `mkOption` with explicit `type`, `default`, and `description`:

```nix
options.modules.<name> = {
  enable = mkEnableOption "Enable <name> configuration";

  fontSize = mkOption {
    type = types.int;
    default = 11;
    description = "<name> font size";
  };
};
```

Reference options via `cfg.<optionName>` in the config block.

## Module Type Guide

| Type | Path | Namespace | Use for |
|------|------|-----------|---------|
| System | `system/<name>/` | `modules.<name>` | NixOS services, kernel modules, systemd units |
| Darwin | `darwin/<name>/` | `modules.<name>` | macOS LaunchAgents, system prefs, Homebrew |
| Home | `home/<name>/` | `modules.<name>` | Cross-platform user config, `programs.<name>` |

### Package group modules

For **unconfigured packages** (no dotfiles, just install), add to existing package groups instead of creating a new module:

| Group | Path | Namespace |
|-------|------|-----------|
| CLI base | `home/packages/base/` | `modules.packages.base` |
| CLI dev | `home/packages/development/` | `modules.packages.development` |
| CLI media | `home/packages/media/` | `modules.packages.media` |
| NixOS GUI | `system/gui-apps/<category>/` | `modules.gui-apps.<category>` |
| macOS GUI | `darwin/gui-apps/<category>/` | `modules.gui-apps.<category>` |

**Do NOT** add packages here if they have dedicated config modules — that causes duplicate package errors.

## Shared Constants

When the module needs colors or fonts:

```nix
let
  colors = import ../../common/colors.nix;    # Catppuccin palette
  fonts = import ../../common/fonts { inherit pkgs; };
in { ... }
```

Adjust the relative path depth based on module location.

## After Generation

### Enable the module

```nix
# System/Darwin modules — in hosts/<hostname>/default.nix:
modules.<name>.enable = true;

# Home modules — in users/andrew/home/default.nix (shared)
# or users/andrew/home/<hostname>/default.nix (host-specific):
modules.<name>.enable = true;
```

### Test before switching

```bash
# NixOS
sudo nixos-rebuild build --flake .#<hostname>

# macOS
darwin-rebuild build --flake .
```
