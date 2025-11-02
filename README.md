# nix-config

## References

- Much of this configuration is inspired by [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config/tree/i3-kickstarter) and the accompanying [NixOS & Flakes](https://nixos-and-flakes.thiscute.world/) book.
- For hardware-specific presets, see [nixos/nixos-hardware](https://github.com/NixOS/nixos-hardware).

## Instructions

### yorha2b - main pc

1. Copy ssh keys to `~/.ssh`
2. Apply correct permissions:

```bash
chmod -R 700 ~/.ssh/
chmod 600 ~/.ssh/*
chmod 644 ~/.ssh/*.pub
```

3. Clone nix-config repo

```bash
nix-shell -p git
git clone git@github.com:andrewyazura/nix-config.git
```

4. Copy new `hardware-config.nix` to `hosts/yorha2b/hardware-config.nix`
5. Apply config

```bash
sudo nixos-rebuild switch --flake .#yorha2b
```

### remote machine

```
nixos-rebuild --flake .#<machine> --target-host andrew@<machine> switch --sudo
```
