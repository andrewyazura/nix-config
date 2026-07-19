# CS2 Server Update Guide

This guide details how to update the Counter-Strike 2 server executable and its accompanying plugins (Metamod, CounterStrikeSharp, MatchZy) in this Nix configuration.

---

## 1. Updating the Counter-Strike 2 Game Executable
The core game executable is managed automatically by SteamCMD inside the systemd service pre-start script defined in [default.nix](file:///home/andrew/Documents/nix/config/system/cs2-server/default.nix):

```nix
preStart = ''
  ${pkgs.steamcmd}/bin/steamcmd \
    +force_install_dir ${installDir} \
    +login anonymous \
    +app_update 730 \
    +quit
...
'';
```

- **When it updates**: Every time the systemd service starts or restarts, SteamCMD will query Valve's servers for updates and download them if available.
- **How to trigger an update manually**:
  Run this command on the target host:
  ```bash
  sudo systemctl restart cs2-<server-name>
  ```
  *(e.g., `sudo systemctl restart cs2-default` or whatever server name is defined in your configurations).*

---

## 2. Updating the CS2 Plugins
Plugins are pinned via fixed-output derivations in [plugins.nix](file:///home/andrew/Documents/nix/config/system/cs2-server/plugins.nix). To update them to their latest versions, follow these steps:

### Step 1: Find the latest versions and URLs

1. **Metamod:Source (2.0.0 Dev Builds)**:
   - Visit: [Metamod 2.0.0 Snapshots](https://mms.alliedmods.net/mmsdrop/2.0/)
   - Find the latest build matching `mmsource-2.0.0-gitXXXX-linux.tar.gz`.
   - Record the URL: `https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-gitXXXX-linux.tar.gz`

2. **CounterStrikeSharp**:
   - Visit: [CounterStrikeSharp Releases](https://github.com/roflmuffin/CounterStrikeSharp/releases)
   - Find the latest release version (e.g., `v1.0.371`).
   - Use the release version to construct the download URL for the package with pre-bundled runtime:
     `https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v1.0.XXXX/counterstrikesharp-with-runtime-linux-1.0.XXXX.zip`

3. **MatchZy-Enhanced**:
   - Visit: [MatchZy-Enhanced Releases](https://github.com/sivert-io/MatchZy-Enhanced/releases)
   - Find the latest release version (e.g., `v1.4.21`).
   - Construct the download URL:
     `https://github.com/sivert-io/MatchZy-Enhanced/releases/download/vX.Y.Z/MatchZy-X.Y.Z.zip`

### Step 2: Prefetch the Nix SHA256 Hashes
For each of the new URLs, compute the Nix store hash using `nix-prefetch-url`:

```bash
nix-prefetch-url <URL>
```

Example commands:
```bash
nix-prefetch-url https://mms.alliedmods.net/mmsdrop/2.0/mmsource-2.0.0-git1407-linux.tar.gz
nix-prefetch-url https://github.com/roflmuffin/CounterStrikeSharp/releases/download/v1.0.371/counterstrikesharp-with-runtime-linux-1.0.371.zip
```

### Step 3: Update `plugins.nix`
Open [plugins.nix](file:///home/andrew/Documents/nix/config/system/cs2-server/plugins.nix) and update:
1. The `url` fields to point to the new versions.
2. The `sha256` fields with the prefetch hashes you just computed.

### Step 4: Verify the Plugin Build Locally
Before deploying, run the following command from the `system/cs2-server/` directory to ensure that the plugins download and extract without issues:

```bash
nix-build -E 'with import <nixpkgs> {}; callPackage ./plugins.nix {}'
```

If it builds successfully, the `result` symlink in that directory will point to the new `/nix/store/...-cs2-plugins-1.0` path.

---

## 3. Deploying the Configuration
After updating and verifying the configuration files, apply them using one of the following methods depending on your target host:

### For local deployment (e.g., `yorha2b` or `yorha9s`):
```bash
sudo nixos-rebuild switch --flake .#<machine-name>
```

### For remote target machines:
```bash
nixos-rebuild --flake .#<machine-name> --target-host andrew@<machine-name> switch --sudo
```

### Or using `deploy-rs`:
```bash
nix run github:serokell/deploy-rs -- .#<machine-name>
```
