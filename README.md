# nix-config

## Structure

Everything is split into separate modules:

- **`system/`** – System-wide configurations (e.g., hardware, system services, display managers).
- **`home/`** – Home Manager configurations (user-level settings, programs, and dotfiles).

These modules are then imported by per-user and per-machine configurations:

- **`hosts/`** – Contains host-specific configurations. Each host directory typically has:
  - `default.nix` (and possibly a `hardware-configuration.nix`)  
  - Imports relevant modules from `system/`
- **`users/`** – Contains user-specific configurations. Each user directory includes:
  - `home.nix` for Home Manager settings
  - `system.nix` for system-level settings that can’t be fully handled by Home Manager (e.g., Hyprland)

## References

- Much of this configuration is inspired by [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config/tree/i3-kickstarter) and the accompanying [NixOS & Flakes](https://nixos-and-flakes.thiscute.world/) book.
- For hardware-specific presets, see [nixos/nixos-hardware](https://github.com/NixOS/nixos-hardware).

