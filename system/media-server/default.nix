{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.media-server;

  qbittorrentNatpmp = pkgs.writeShellApplication {
    name = "qbittorrent-natpmp";
    runtimeInputs = with pkgs; [
      curl
      gawk
      iptables
      libnatpmp
    ];
    text = ''
      iptables -N natpmp || iptables -F natpmp
      iptables -C INPUT -i proton0 -j natpmp || iptables -A INPUT -i proton0 -j natpmp

      current=""
      while true; do
        port=$(natpmpc -a 1 0 tcp 60 -g 10.2.0.1 | awk '/Mapped public port/ { print $4 }')
        natpmpc -a 1 0 udp 60 -g 10.2.0.1 > /dev/null

        if [ "$port" != "$current" ]; then
          iptables -F natpmp
          iptables -A natpmp -p tcp --dport "$port" -j ACCEPT
          iptables -A natpmp -p udp --dport "$port" -j ACCEPT
          current=$port
        fi

        curl -fsS --data "json={\"listen_port\":$port}" \
          http://127.0.0.1:${toString config.services.qbittorrent.webuiPort}/api/v2/app/setPreferences || true

        sleep 45
      done
    '';
  };

  qbittorrentStalled = pkgs.writeShellApplication {
    name = "qbittorrent-stalled";
    runtimeInputs = with pkgs; [
      curl
      jq
    ];
    text = ''
      qbittorrent=http://${config.vpnNamespaces.proton.namespaceAddress}:${toString config.services.qbittorrent.webuiPort}/api/v2
      state=$STATE_DIRECTORY/state.json
      now=$(date +%s)
      [ -f "$state" ] || echo '{}' > "$state"

      curl -fsS "$qbittorrent/torrents/info" \
        | jq --argjson now "$now" --argjson transfer "$(curl -fsS "$qbittorrent/transfer/info")" --slurpfile old "$state" '
            ($transfer.dl_info_data + $transfer.up_info_data) as $total
            | ($total > ($old[0].total // 0)) as $online
            | {
                total: $total,
                torrents: map(
                  select(.state | IN("downloading", "stalledDL", "metaDL", "forcedDL", "forcedMetaDL"))
                  | $old[0].torrents[.hash] as $o
                  | {key: .hash, value: (if $online and $o.downloaded == .downloaded then $o else {downloaded, since: $now} end)}
                ) | from_entries
              }' > "$state.new"
      mv "$state.new" "$state"

      dead=$(jq -c --argjson now "$now" '[.torrents | to_entries[] | select($now - .value.since >= 1800) | .key]' "$state")

      remove() {
        stalled=$(curl -fsS -H "X-Api-Key: $2" "http://127.0.0.1:$1/api/v3/queue?pageSize=10000" \
          | jq -c --argjson dead "$dead" '[.records[] | select(.downloadId // "" | ascii_downcase | IN($dead[]))]')
        if [ "$stalled" != "[]" ]; then
          jq -r '.[].title' <<< "$stalled" | sort -u
          curl -fsS -o /dev/null -X DELETE -H "X-Api-Key: $2" -H "Content-Type: application/json" \
            --data "$(jq -c '{ids: map(.id)}' <<< "$stalled")" \
            "http://127.0.0.1:$1/api/v3/queue/bulk?removeFromClient=true&blocklist=true&skipRedownload=false"
        fi
      }

      remove ${toString config.services.radarr.settings.server.port} "$RADARR__AUTH__APIKEY"
      remove ${toString config.services.sonarr.settings.server.port} "$SONARR__AUTH__APIKEY"
    '';
  };
in
{
  imports = [ inputs.vpn-confinement.nixosModules.default ];

  options.modules.media-server = {
    enable = lib.mkEnableOption "Jellyfin with Sonarr, Radarr and qBittorrent behind ProtonVPN";

    dataDir = lib.mkOption {
      type = lib.types.str;
      description = "Directory for films, shows and torrents. It must be one filesystem, so that hardlinks work.";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      jellyfin = {
        enable = true;
        forceEncodingConfig = true;

        hardwareAcceleration = {
          enable = true;
          type = "vaapi";
        };

        transcoding = {
          enableHardwareEncoding = true;
          hardwareDecodingCodecs = {
            h264 = true;
            hevc = true;
            hevc10bit = true;
            vp9 = true;
            av1 = true;
          };
          hardwareEncodingCodecs = {
            hevc = true;
          };
        };
      };

      qbittorrent = {
        enable = true;
        group = "media";
        serverConfig = {
          LegalNotice.Accepted = true;
          BitTorrent.Session = {
            DefaultSavePath = "${cfg.dataDir}/torrents";
            DisableAutoTMMByDefault = false;
            QueueingSystemEnabled = true;
            IgnoreSlowTorrentsForQueueing = true;
            MaxActiveDownloads = 6;
            MaxActiveTorrents = -1;
            AlternativeGlobalDLSpeedLimit = 5120;
            AlternativeGlobalUPSpeedLimit = 1024;
            DiskIOType = "Posix";
            GlobalMaxRatio = 2;
            GlobalMaxSeedingMinutes = 43200;
            ShareLimitAction = "Stop";
          };
          Preferences = {
            Connection.UPnP = false;
            WebUI = {
              LocalHostAuth = false;
              AuthSubnetWhitelistEnabled = true;
              AuthSubnetWhitelist = "192.168.15.0/24";
            };
          };
        };
      };

      sonarr = {
        enable = true;
        group = "media";
        environmentFiles = [ config.sops.templates.sonarr-env.path ];
        settings.server.port = 8990;
      };

      radarr = {
        enable = true;
        group = "media";
        environmentFiles = [ config.sops.templates.radarr-env.path ];
      };

      bazarr = {
        enable = true;
        group = "media";
      };

      prowlarr.enable = true;
      seerr.enable = true;

      recyclarr = {
        enable = true;
        configuration = {
          radarr.radarr = {
            base_url = "http://127.0.0.1:7878";
            api_key._secret = config.sops.secrets.radarr-api-key.path;
            media_naming = {
              folder = "jellyfin-tmdb";
              movie = {
                rename = true;
                standard = "jellyfin-tmdb";
              };
            };
            quality_definition = {
              type = "movie";
              qualities = [
                {
                  name = "Bluray-1080p";
                  min = 12.5;
                }
                {
                  name = "Bluray-720p";
                  min = 12.5;
                }
              ];
            };
            quality_profiles = [
              {
                trash_id = "d1d67249d3890e49bc12e275d989a7e9";
                reset_unmatched_scores.enabled = true;
              }
            ];
            custom_format_groups.skip = [ "f8bf8eab4617f12dfdbd16303d8da245" ];
            custom_formats = [
              {
                trash_ids = [ "9170d55c319f4fe40da8711ba9d8050d" ];
                assign_scores_to = [
                  {
                    trash_id = "d1d67249d3890e49bc12e275d989a7e9";
                    score = 2000;
                  }
                ];
              }
            ];
          };

          sonarr.sonarr = {
            base_url = "http://127.0.0.1:8990";
            api_key._secret = config.sops.secrets.sonarr-api-key.path;
            media_naming = {
              series = "jellyfin-tvdb";
              season = "default";
              episodes = {
                rename = true;
                standard = "default";
              };
            };
            quality_definition = {
              type = "series";
              qualities = [
                {
                  name = "Bluray-1080p";
                  min = 15;
                }
              ];
            };
            quality_profiles = [
              {
                trash_id = "72dae194fc92bf828f32cde7744e51a1";
                reset_unmatched_scores.enabled = true;
                qualities = [
                  {
                    name = "1080p";
                    qualities = [
                      "Bluray-1080p"
                      "WEBDL-1080p"
                      "WEBRip-1080p"
                    ];
                  }
                ];
                upgrade = {
                  allowed = true;
                  until_quality = "1080p";
                  until_score = 2000;
                };
              }
            ];
            custom_format_groups.skip = [ "158188097a58d7687dee647e04af0da3" ];
            custom_formats = [
              {
                trash_ids = [ "c9eafd50846d299b862ca9bb6ea91950" ];
                assign_scores_to = [
                  {
                    trash_id = "72dae194fc92bf828f32cde7744e51a1";
                    score = 2000;
                  }
                ];
              }
            ];
          };
        };
      };
    };

    vpnNamespaces.proton = {
      enable = true;
      wireguardConfigFile = config.sops.secrets.proton-wireguard.path;
      portMappings = [
        {
          from = config.services.qbittorrent.webuiPort;
          to = config.services.qbittorrent.webuiPort;
        }
      ];
    };

    systemd = {
      services = lib.mkMerge [
        (lib.genAttrs [ "qbittorrent" "sonarr" "radarr" "bazarr" ] (_: {
          serviceConfig.UMask = lib.mkForce "0002";
        }))
        (lib.genAttrs [ "qbittorrent" "sonarr" "radarr" "prowlarr" "bazarr" ] (_: {
          serviceConfig.CPUSchedulingPolicy = "idle";
        }))
        {
          qbittorrent = {
            vpnConfinement = {
              enable = true;
              vpnNamespace = "proton";
            };
            serviceConfig.ExecStartPre = [
              "${pkgs.coreutils}/bin/rm -f ${config.services.qbittorrent.profileDir}/qBittorrent/config/lockfile"
            ];
          };

          qbittorrent-natpmp = {
            description = "ProtonVPN port forwarding for qBittorrent";
            wantedBy = [ "multi-user.target" ];
            after = [ "qbittorrent.service" ];
            vpnConfinement = {
              enable = true;
              vpnNamespace = "proton";
            };
            serviceConfig = {
              ExecStart = lib.getExe qbittorrentNatpmp;
              Restart = "always";
              RestartSec = 10;
            };
          };

          qbittorrent-stalled = {
            description = "Replace qBittorrent downloads with no progress for 30 minutes";
            after = [
              "qbittorrent.service"
              "radarr.service"
              "sonarr.service"
            ];
            startAt = "*:0/5";
            serviceConfig = {
              Type = "oneshot";
              ExecStart = lib.getExe qbittorrentStalled;
              EnvironmentFile = [
                config.sops.templates.radarr-env.path
                config.sops.templates.sonarr-env.path
              ];
              DynamicUser = true;
              StateDirectory = "qbittorrent-stalled";
            };
          };
        }
      ];

      tmpfiles.settings.media-server =
        lib.genAttrs
          [
            "${cfg.dataDir}/films"
            "${cfg.dataDir}/shows"
            "${cfg.dataDir}/torrents"
          ]
          (_: {
            d = {
              user = "root";
              group = "media";
              mode = "2775";
            };
          });
    };

    programs.gamemode.settings.custom =
      let
        speedLimitsMode =
          mode:
          "${lib.getExe pkgs.curl} -s -X POST -d mode=${mode} http://${config.vpnNamespaces.proton.namespaceAddress}:${toString config.services.qbittorrent.webuiPort}/api/v2/transfer/setSpeedLimitsMode";
      in
      {
        start = speedLimitsMode "1";
        end = speedLimitsMode "0";
      };

    users.groups.media = { };

    sops = {
      secrets = {
        proton-wireguard = {
          sopsFile = ../../secrets/proton-wireguard;
          format = "binary";
        };
        radarr-api-key.sopsFile = ../../secrets/media-server.yaml;
        sonarr-api-key.sopsFile = ../../secrets/media-server.yaml;
      };

      templates = {
        radarr-env.content = "RADARR__AUTH__APIKEY=${config.sops.placeholder.radarr-api-key}";
        sonarr-env.content = "SONARR__AUTH__APIKEY=${config.sops.placeholder.sonarr-api-key}";
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
      5055
      6767
      7878
      8096
      8990
      9696
    ];
  };
}
