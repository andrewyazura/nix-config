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

## Instructions

### r7-x3d

1. Enable GPG agent in `/etc/nixos/configuration.nix`:

```nix
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
};
```

2. Rebuild and reboot

```bash
sudo nixos-rebuild switch
```

3. Copy SSH and GPG keys from backup
4. Import GPG keys

```bash
gpg --import secret-backup.gpg
```

5. Copy ssh keys to `~/.ssh`
6. Apply correct permissions:

```bash
chmod -R 700 ~/.ssh/
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub
```

7. Clone nix-config repo and unlock encrypted files

```bash
nix-shell -p git git-crypt
git-crypt unlock
```

9. Copy new `hardware-config.nix` to `hosts/r7-x3d/hardware-config.nix`
10. Apply config

```bash
sudo nixos-rebuild switch --flake .#r7-x3d
```

### hetzner

```
nixos-rebuild --flake .#hetzner --target-host andrew@hetzner-nix --use-remote-sudo switch
```
