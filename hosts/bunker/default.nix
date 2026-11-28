{
  config,
  hostname,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cloudflareIpv4 = [
    "173.245.48.0/20"
    "103.21.244.0/22"
    "103.22.200.0/22"
    "103.31.4.0/22"
    "141.101.64.0/18"
    "108.162.192.0/18"
    "190.93.240.0/20"
    "188.114.96.0/20"
    "197.234.240.0/22"
    "198.41.128.0/17"
    "162.158.0.0/15"
    "104.16.0.0/13"
    "104.24.0.0/14"
    "172.64.0.0/13"
    "131.0.72.0/22"
  ];

  cloudflareIpv6 = [
    "2400:cb00::/32"
    "2606:4700::/32"
    "2803:f800::/32"
    "2405:b500::/32"
    "2405:8100::/32"
    "2a06:98c0::/29"
    "2c0f:f248::/32"
  ];
in
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko-config.nix

    ../../users/andrew/system
    ../../users/andrew/system/bunker

    ./apps/attic
    ./apps/beast-music.nix
    ./apps/bingo.nix
    ./apps/birthday-api.nix
    ./apps/birthday-bot.nix
    ./apps/claude-agent.nix
    ./apps/minecraft.nix
    ./apps/monitoring.nix
    ./apps/ntfy.nix
    ./apps/oauth-consent.nix
    ./apps/stresses-bot.nix
  ];

  modules = {
    beammp-server = {
      enable = false;

      servers = {
        akina = {
          port = 3814;
          environmentFiles = [
            config.sops.secrets.beammp-akina-env.path
          ];
        };
      };
    };

    cs2-server = {
      enable = false;

      servers = {
        server-1 = {
          port = 27015;
          tvPort = 27020;
          tickrate = 64;
          admins = {
            "kenough" = {
              identity = "76561198341773564";
            };
            "yaroslave" = {
              identity = "76561198028746163";
            };
            "chief" = {
              identity = "76561199008224083";
            };
          };
          environmentFiles = [
            config.sops.secrets.cs2-env.path
          ];
          workshopMaps = [
            "3070244462" # Aim Botz
            "3100869952" # Recoil Master
          ];
        };
      };
    };

    tailscale.enable = true;
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
    ];

    home.stateVersion = "25.11";
  };

  nix.settings = {
    trusted-users = [ "@wheel" ];
  };

  documentation.nixos.enable = false;
  time.timeZone = lib.mkForce "UTC";
  console.keyMap = "us";

  boot = {
    loader.grub.enable = true;
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci" # Required for Hetzner Cloud
      "virtio_scsi" # Required for Hetzner Cloud
      "sd_mod"
      "sr_mod"
      "ext4"
    ];
  };

  users.mutableUsers = false;
  users.users = {
    root.hashedPassword = "!";

    deploy = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.bash;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN8nY1Ba470FDscLuFJsTeScqBcxruyx7b5rlHntvex1"
      ];
    };
  };
  security.sudo.wheelNeedsPassword = false;

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      "andrewyazura.crt" = {
        sopsFile = ../../secrets/andrewyazura.crt;
        format = "binary";

        owner = "nginx";
        group = "nginx";
        mode = "0400";
      };

      "andrewyazura.key" = {
        sopsFile = ../../secrets/andrewyazura.key;
        format = "binary";

        owner = "nginx";
        group = "nginx";
        mode = "0400";
      };

      "bin9o.crt" = {
        sopsFile = ../../secrets/bin9o.crt;
        format = "binary";

        owner = "nginx";
        group = "nginx";
        mode = "0400";
      };

      "bin9o.key" = {
        sopsFile = ../../secrets/bin9o.key;
        format = "binary";

        owner = "nginx";
        group = "nginx";
        mode = "0400";
      };

      attic-env = {
        sopsFile = ../../secrets/attic-env;
        format = "binary";
      };

      beammp-akina-env = {
        sopsFile = ../../secrets/beammp-akina-env;
        format = "binary";
      };

      cs2-env = {
        sopsFile = ../../secrets/cs2-env;
        format = "binary";
        restartUnits = [ "cs2-server-1.service" ];
      };

      minecraft-ledger-env = {
        sopsFile = ../../secrets/minecraft-ledger-env;
        format = "binary";
        restartUnits = [ "minecraft-server-bombas.service" ];
      };

      netrc = {
        sopsFile = ../../secrets/netrc-bunker;
        format = "binary";
      };

      ntfy-env = {
        sopsFile = ../../secrets/ntfy-env;
        format = "binary";
        restartUnits = [ "ntfy-sh.service" ];
      };

      rclone-config = {
        sopsFile = ../../secrets/rclone-gdrive-minecraft-backups-config;
        format = "binary";
        owner = "minecraft";
        group = "minecraft";
        mode = "0400";
      };

      rclone-config-postgres = {
        sopsFile = ../../secrets/rclone-gdrive-minecraft-backups-config;
        format = "binary";
        owner = "postgres";
        group = "postgres";
        mode = "0400";
      };

      restic-password-minecraft = {
        sopsFile = ../../secrets/restic-password;
        format = "binary";
        owner = "minecraft";
        group = "minecraft";
        mode = "0400";
      };

      restic-password-postgres = {
        sopsFile = ../../secrets/restic-password;
        format = "binary";
        owner = "postgres";
        group = "postgres";
        mode = "0400";
      };
    };
  };

  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  services = {
    openssh = {
      enable = true;
      openFirewall = false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      statusPage = true;
      appendHttpConfig = ''
        ${lib.concatMapStrings (ip: "set_real_ip_from ${ip};\n") (cloudflareIpv4 ++ cloudflareIpv6)}
        real_ip_header CF-Connecting-IP;

        map $host $limit_req_key {
          cache.andrewyazura.com "";
          default $binary_remote_addr;
        }

        limit_req_zone $limit_req_key zone=general:10m rate=20r/s;
        limit_req zone=general burst=100 nodelay;
        limit_req_status 429;
      '';
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
    };

    restic.backups.postgres = {
      user = "postgres";
      repository = "rclone:gdrive-minecraft-backups:restic/postgres";
      passwordFile = config.sops.secrets.restic-password-postgres.path;
      rcloneConfigFile = config.sops.secrets.rclone-config-postgres.path;
      initialize = true;
      paths = [ "/var/lib/restic-staging/postgres" ];
      timerConfig = {
        OnCalendar = "*-*-* 03:30:00";
        Persistent = true;
      };
      pruneOpts = [
        "--keep-daily 14"
        "--keep-weekly 8"
        "--keep-monthly 12"
      ];
      backupPrepareCommand = lib.getExe (
        pkgs.writeShellApplication {
          name = "restic-prepare-postgres";
          runtimeInputs = [
            pkgs.coreutils
            pkgs.findutils
            config.services.postgresql.finalPackage
          ];
          text = ''
            staging=/var/lib/restic-staging/postgres
            find "$staging" -mindepth 1 -delete
            pg_dumpall --globals-only > "$staging/globals.sql"
            databases=$(psql -XAt -v ON_ERROR_STOP=1 -c "select datname from pg_database where not datistemplate and datname <> 'postgres' order by 1")
            for db in $databases; do
              case " ''${EXCLUDE_DATABASES:-} " in
                *" $db "*) ;;
                *) pg_dump "$db" > "$staging/$db.sql" ;;
              esac
            done
          '';
        }
      );
    };

    journald.settings.Journal = {
      SystemMaxUse = "2G";
      MaxRetentionSec = "1month";
    };
  };

  systemd.services = lib.mkMerge [
    (lib.mapAttrs' (
      name: _:
      lib.nameValuePair "restic-backups-${name}" {
        serviceConfig = {
          CapabilityBoundingSet = "";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "@chown"
          ];
          UMask = "0077";
        };
      }
    ) config.services.restic.backups)
    {
      restic-backups-postgres = {
        after = [ "postgresql.target" ];
        wants = [ "postgresql.target" ];
        serviceConfig = {
          StateDirectory = "restic-staging/postgres";
          StateDirectoryMode = "0700";
        };
      };
    }
  ];

  networking.firewall.extraCommands =
    lib.concatMapStrings (ip: ''
      iptables -A nixos-fw -p tcp -s ${ip} -m multiport --dports 80,443 -j nixos-fw-accept
    '') cloudflareIpv4
    + lib.concatMapStrings (ip: ''
      ip6tables -A nixos-fw -p tcp -s ${ip} -m multiport --dports 80,443 -j nixos-fw-accept
    '') cloudflareIpv6;
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

  networking.hostName = hostname;

  system.stateVersion = "25.11";
}
