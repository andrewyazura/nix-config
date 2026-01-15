---
name: nix-module
description: Generate new Nix configuration modules following the repository's standard pattern. Creates module boilerplate in system/, darwin/, or home/ directories with proper options structure, imports parent default.nix automatically, and follows best practices for module organization.
---

# Nix Module Generator

Scaffolds new Nix modules following this repository's architectural patterns.

## Usage

Just describe what module you want to create:
- "Create a new system module for audio-pro configuration"
- "Add a darwin module for Rectangle window manager"
- "Generate a home module for alacritty terminal"

The skill will:
1. Ask clarifying questions if needed (module type, name, additional options)
2. Generate the module file with standard structure
3. Add the import to parent `default.nix`
4. Verify the module follows repository patterns

## Module Types

### System Modules (`system/<name>/`)
- **Purpose:** NixOS-specific system configuration
- **Namespace:** `config.modules.<name>`
- **Examples:** audio, networking, gnome, i3, minecraft-server
- **Typical contents:** systemd services, system packages, kernel modules

### Darwin Modules (`darwin/<name>/`)
- **Purpose:** macOS-specific system configuration
- **Namespace:** `config.modules.<name>`
- **Examples:** aerospace, homebrew, system-defaults
- **Typical contents:** LaunchAgents, system preferences, macOS-specific packages

### Home Modules (`home/<name>/`)
- **Purpose:** Cross-platform user environment configuration
- **Namespace:** `config.modules.<name>`
- **Examples:** git, neovim, tmux, zsh, ghostty
- **Typical contents:** dotfiles, user packages, application configs

## Standard Module Pattern

All modules follow this structure:

```nix
{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.<name>;
in
{
  options.modules.<name> = {
    enable = mkEnableOption "Enable <name> configuration";
    # Additional options if needed (fonts, colors, ports, etc.)
  };

  config = mkIf cfg.enable {
    # Implementation goes here
  };
}
```

## When to Add Additional Options

**✅ DO add options for:**
- Configuration that varies per host (fonts, colors, display settings)
- Feature flags within the module (enable-plugins, use-wayland)
- Resource limits (memory, ports, timeouts)
- Complex nested configuration (servers, profiles, themes)

**❌ DON'T add options for:**
- Implementation details users shouldn't customize
- Values that should be consistent across all hosts
- Temporary configuration (use host overrides instead)

## Best Practices

### Module Organization
- One feature per module (don't combine unrelated config)
- Keep modules self-contained (minimal cross-module dependencies)
- Use conditional config: `mkIf cfg.enable { ... }`

### Cross-Module Dependencies
```nix
# BAD: Assumes another module is enabled
config = mkIf cfg.enable {
  xsession.windowManager.i3.config.startup = [ ... ];
};

# GOOD: Guard cross-module config
config = mkIf cfg.enable {
  xsession.windowManager.i3 = mkIf (config.xsession.windowManager.i3.enable or false) {
    config.startup = [ ... ];
  };
};
```

### Importing Shared Constants
```nix
# Colors (Catppuccin palette)
let
  colors = import ../../common/colors.nix;
in {
  foreground = "${colors.text}";
  background = "${colors.base}";
}

# Fonts
let
  fonts = import ../../common/fonts { inherit pkgs; };
in {
  home.packages = fonts;
}
```

## Examples

### Simple Module (git)
```nix
{ lib, config, ... }:
with lib;
let cfg = config.modules.git;
in {
  options.modules.git = {
    enable = mkEnableOption "Enable git configuration";
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Your Name";
      userEmail = "your@email.com";
    };
  };
}
```

### Module with Options (ghostty)
```nix
{ lib, config, ... }:
with lib;
let cfg = config.modules.ghostty;
in {
  options.modules.ghostty = {
    enable = mkEnableOption "Enable ghostty configuration";

    fontFamily = mkOption {
      type = types.str;
      default = "AdwaitaMono Nerd Font";
      description = "Ghostty font family";
    };

    fontSize = mkOption {
      type = types.int;
      default = 11;
      description = "Ghostty font size";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        font-family = cfg.fontFamily;
        font-size = cfg.fontSize;
      };
    };
  };
}
```

### Complex Module (minecraft-server)
```nix
{ lib, config, pkgs, inputs, ... }:
with lib;
let cfg = config.modules.minecraft-server;
in {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.modules.minecraft-server = {
    enable = mkEnableOption "Enable Minecraft server configuration";

    servers = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          jvmOpts = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
          serverProperties = mkOption {
            type = types.attrsOf (types.oneOf [ types.bool types.int types.str ]);
            default = {};
          };
        };
      });
      default = {};
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
    services.minecraft-servers = {
      enable = true;
      # Server configuration...
    };
  };
}
```

## Workflow

When you invoke this skill, it will:

1. **Clarify requirements**
   - Ask for module type (system/darwin/home) if not specified
   - Ask for module name (kebab-case preferred)
   - Ask if additional options needed beyond `enable`

2. **Generate module file**
   - Create `<type>/<name>/default.nix`
   - Follow standard pattern
   - Include helpful comments

3. **Update parent imports**
   - Add `./<name>` to `<type>/default.nix` imports
   - Maintain alphabetical order

4. **Provide next steps**
   - How to enable the module in host config
   - Where to add implementation details
   - Examples of similar modules to reference

## After Generation

### Enable in Host Config
```nix
# hosts/<hostname>/default.nix
modules = {
  <name>.enable = true;  # For system/darwin modules
};

# OR for home modules:
home-manager.users.andrew = {
  modules = {
    <name>.enable = true;
  };
};
```

### Test the Module
```bash
# For NixOS
sudo nixos-rebuild build --flake .#<hostname>

# For Darwin
darwin-rebuild build --flake .

# Check for errors, then switch
sudo nixos-rebuild switch --flake .#<hostname>
# or
sudo darwin-rebuild switch --flake .
```

## Troubleshooting

### "Infinite recursion encountered"
- Usually from circular module dependencies
- Check for `config.modules.X` references in let bindings
- Use `mkIf` guards properly

### "The option modules.<name> does not exist"
- Module not imported in parent default.nix
- Check spelling matches between file and option name

### "Attribute already exists"
- Another module setting same config
- Use `mkMerge` or `mkOverride` to combine

## Related Documentation

- **CLAUDE.md** - Repository architecture overview
- **Module pattern** - See any existing module for reference
- **Common directory** - Shared constants (colors, fonts, nix settings)
