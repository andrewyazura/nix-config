# CS2 Server Update Guide

This guide details how to update the Counter-Strike 2 server executable and its accompanying plugins (Ready Up) in this Nix configuration.

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

1. **Ready Up**:
   - Visit: [Ready Up Releases](https://github.com/Auto-Tournament/ready-up/releases)
   - Find the latest release version (e.g., `v0.2.33`). Its release notes name
     the CS2 build its engine signatures were verified against.
   - Each entry of `readyupComponents` is one single-component release zip:
     `https://github.com/Auto-Tournament/ready-up/releases/download/vX.Y.Z/ready-up-<component>-X.Y.Z-linuxsteamrt64.zip`
     (`essentials-plugin` is the essentials plugin alone; `ready-up-essentials-...`
     without `-plugin` is the bundle). The bundles are not used, so `hud` and
     `addons` stay out.
   - A CS2 update can break Ready Up's engine signatures. Run `ru selftest` in
     the server console after one; it ends with `PASS` or `FAIL`. On `FAIL`,
     move to a release verified against the new CS2 build.

### Step 2: Prefetch the Nix SHA256 Hashes
For each of the new URLs, compute the Nix store hash using `nix-prefetch-url`:

```bash
nix-prefetch-url <URL>
```

Example commands:
```bash
nix-prefetch-url https://github.com/Auto-Tournament/ready-up/releases/download/v0.2.33/ready-up-core-0.2.33-linuxsteamrt64.zip
nix-prefetch-url https://github.com/Auto-Tournament/ready-up/releases/download/v0.2.33/ready-up-match-0.2.33-linuxsteamrt64.zip
```

### Step 3: Update `plugins.nix`
Open [plugins.nix](file:///home/andrew/Documents/nix/config/system/cs2-server/plugins.nix) and update:
1. `readyupVersion` to the new version.
2. The hashes in `readyupComponents` with the prefetch hashes you just computed.

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

---

## 4. Managing Steam Workshop Maps and Collections
You can configure Steam Workshop maps and collections directly in the Nix config.

### Launching a Single Workshop Map on Startup
To start the server directly on a Workshop map:
1. Locate the Map ID from the Steam Workshop URL (e.g., `3070288532`).
2. Set the `map` attribute in your host configuration to this ID:
   ```nix
   modules.cs2-server.servers.server-1 = {
     map = "3070288532"; 
     # (The Nix config automatically detects numeric IDs and uses +host_workshop_map instead of +map)
   };
   ```

### Hosting a Workshop Map Collection
To start the server with a pre-configured Workshop Collection (allowing rotation/voting):
1. Obtain the Collection ID from the Steam Workshop collection URL.
2. Set the `workshopCollection` option in your host configuration:
   ```nix
   modules.cs2-server.servers.server-1 = {
     workshopCollection = "YOUR_COLLECTION_ID";
   };
   ```

### Populating the Map Pool and Voting Menus
To provide a custom list of Workshop map IDs that plugins (like map choosers) can use for voting, map cycling, or practice commands:
1. Define the `workshopMaps` list of map ID strings in your server definition:
   ```nix
   modules.cs2-server.servers.server-1 = {
     workshopMaps = [
       "3070288532" # Map ID 1
       "3070290869" # Map ID 2
     ];
   };
   ```
2. On startup, the configuration automatically creates and populates `mapcycle.txt` and `maplist.txt` inside your CS2 installation directories with these maps formatted with the standard `ds:` workshop map prefix.

---

## 5. Rotating the Server Credentials

All three secrets live in `secrets/cs2-env`, a sops-encrypted `KEY=value` file:

| Key | Where it comes from |
| --- | --- |
| `GSLT_TOKEN` | <https://steamcommunity.com/dev/managegameservers> — game server account token, app ID 730 |
| `STEAM_WEB_API_KEY` | <https://steamcommunity.com/dev/apikey> |
| `RCON_PASSWORD` | Generate your own, e.g. `head -c 24 /dev/urandom \| base32` |

### Steps

1. Issue the new value at the URL above, or generate it.
2. Edit the secret and replace the line:
   ```bash
   sops secrets/cs2-env
   ```
3. Commit and push. `restartUnits` on the `cs2-env` secret restarts
   `cs2-server-1.service`, so the new values take effect without a manual
   restart.
4. Revoke the old value at Steam once the new one is confirmed live.

### Verifying a rotation

The decrypted secret on the host is `/run/secrets/cs2-env`. Compare it against
the repo without printing either value:

```bash
sops -d secrets/cs2-env | grep -oP '^STEAM_WEB_API_KEY=\K.*' | sha256sum
ssh bunker 'sudo grep -oP "^STEAM_WEB_API_KEY=\K.*" /run/secrets/cs2-env | sha256sum'
```

Matching hashes mean the rotation is live. A mismatch usually means the change
was never committed and pushed, so no deploy ran.

Confirm the server still authenticates:

```bash
ssh bunker 'journalctl -u cs2-server-1 --since "5 min ago" | grep -i "logon token"'
```

### Keeping the secrets out of the journal

Do not pass a secret as a launch argument. The engine prints the CS2 command
line, so anything on it lands in the journal, and in `/proc/<pid>/cmdline`. The engine masks the GSLT
token but **not** `-authkey`.

- `rcon_password` and `sv_setsteamaccount` are convars, so `preStart` writes
  them to `cfg/secrets.cfg` at mode 600 and the server reads it via
  `+exec secrets.cfg`.
- `-authkey` has no convar and must stay on the command line, so
  `LogFilterPatterns` drops the command-line lines before journald stores them.

If a secret does reach the journal, rotate it — vacuuming is time-based and
cannot remove a single recent entry without taking the surrounding logs too.
Check with the value itself, never with a log message:

```bash
ssh bunker 'K=$(sudo grep -oP "^STEAM_WEB_API_KEY=\K.*" /run/secrets/cs2-env)
  journalctl -u cs2-server-1 --no-pager | grep -cF "$K"'
```
