# Media server

Jellyfin, Sonarr, Radarr, Prowlarr, Bazarr, Seerr and Recyclarr on yorha2b.
qBittorrent-nox runs in the `proton` VPN namespace.

## qBittorrent

The WebUI is at `http://192.168.15.1:8080`, from the host only. It needs no
login, because the module whitelists `192.168.15.0/24`. `localhost:8080` does
not work, because the DNAT rule is only in PREROUTING.

Check the VPN connection:

```
curl -s 192.168.15.1:8080/api/v2/transfer/info
```

The output gives `connection_status` and `last_external_address_v4`.

The kill switch is not tested.

## API keys

The Sonarr and Radarr API keys are in `secrets/media-server.yaml`:

```
sops decrypt --extract '["sonarr-api-key"]' secrets/media-server.yaml
```

The Prowlarr and Bazarr keys are not in sops. Each service makes its key at
the first start and keeps it in its state directory.

## Recyclarr

Recyclarr syncs daily. To sync now:

```
sudo systemctl start recyclarr.service
```

## Jellyfin

- Keep **Allow remote connections** on. Jellyfin treats tailnet addresses
  (`100.64.0.0/10`) as remote. Without this setting, it blocks tailnet clients
  with `RejectDueToRemoteAccessDisabled`.
- The firewall opens port 8096 only on `tailscale0`.
- Add a library only after its files are in place. Jellyfin skips an empty
  library folder.

## Import of existing files

Put the files in `/disk_alpha/torrents/import` and do a manual import with
the `move` import mode. The folder is on the same dataset as the library, so
the move is instant. Sonarr and Radarr rename the files.

- With the API, do not give `seriesId` to the Sonarr `manualimport` GET. With
  `seriesId`, Sonarr scans the series folder, not `folder`.
- A Sonarr rescan skips the `Featurettes` folders in the season folders.

## GUI qBittorrent

The GUI qBittorrent (not this module) seeds other folders under
`/disk_alpha`. A plain `mv` breaks those torrents with "missing files". Move
them with **Set location** in the GUI. To see the save paths:

```
strings ~/.local/share/qBittorrent/BT_backup/*.fastresume | grep qBt-savePath
```
