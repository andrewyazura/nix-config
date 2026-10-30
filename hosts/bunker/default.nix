{
  config,
  hostname,
  inputs,
  lib,
  pkgs,
  ...
}:
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
              flags = [ "@css/root" ];
            };
            "yaroslave" = {
              identity = "76561198028746163";
              flags = [ "@css/root" ];
            };
            "chief" = {
              identity = "76561199008224083";
              flags = [ "@css/root" ];
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

    minecraft-server = {
      enable = true;

      servers.bombas = {
        jvmOpts = "-Xms8192M -Xmx8192M -XX:+ExitOnOutOfMemoryError";

        serverProperties = {
          server-port = 25565;
        };

        backup = {
          enable = true;
          remote = "gdrive-minecraft-backups:minecraft-backups";
          rcloneConfigFile = config.sops.secrets.rclone-config.path;
          calendar = "04:00";
          retentionDays = 1;
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
        # Cloudflare IPv4
        set_real_ip_from 173.245.48.0/20;
        set_real_ip_from 103.21.244.0/22;
        set_real_ip_from 103.22.200.0/22;
        set_real_ip_from 103.31.4.0/22;
        set_real_ip_from 141.101.64.0/18;
        set_real_ip_from 108.162.192.0/18;
        set_real_ip_from 190.93.240.0/20;
        set_real_ip_from 188.114.96.0/20;
        set_real_ip_from 197.234.240.0/22;
        set_real_ip_from 198.41.128.0/17;
        set_real_ip_from 162.158.0.0/15;
        set_real_ip_from 104.16.0.0/13;
        set_real_ip_from 104.24.0.0/14;
        set_real_ip_from 172.64.0.0/13;
        set_real_ip_from 131.0.72.0/22;

        # Cloudflare IPv6
        set_real_ip_from 2400:cb00::/32;
        set_real_ip_from 2606:4700::/32;
        set_real_ip_from 2803:f800::/32;
        set_real_ip_from 2405:b500::/32;
        set_real_ip_from 2405:8100::/32;
        set_real_ip_from 2a06:98c0::/29;
        set_real_ip_from 2c0f:f248::/32;

        real_ip_header CF-Connecting-IP;

        limit_req_zone $binary_remote_addr zone=general:10m rate=20r/s;
        limit_req zone=general burst=100 nodelay;
        limit_req_status 429;
      '';
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
    };

    postgresqlBackup = {
      enable = true;
      backupAll = true;
      compression = "zstd";
      startAt = "*-*-* 03:30:00";
    };

    journald.settings.Journal = {
      SystemMaxUse = "2G";
      MaxRetentionSec = "1month";
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 22 ];

  networking.hostName = hostname;

  system.stateVersion = "25.11";
}
