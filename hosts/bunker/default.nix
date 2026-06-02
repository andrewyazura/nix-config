{
  config,
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

    ./apps/attic.nix
    ./apps/beast-music.nix
    ./apps/bingo.nix
    ./apps/birthday-api.nix
    ./apps/birthday-bot.nix
    ./apps/stresses-bot.nix
  ];

  modules = {
    beammp-server = {
      enable = true;

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
          tickrate = 128;
          environmentFiles = [
            config.sops.secrets.cs2-env.path
          ];
        };
      };
    };

    minecraft-server = {
      enable = true;

      servers.bombas = {
        jvmOpts = "-Xms8192M -Xmx8192M";

        serverProperties = {
          server-port = 25565;
        };

        backup = {
          enable = true;
          remote = "gdrive-andrewyazura:minecraft-backups";
          rcloneConfigFile = config.sops.secrets.rclone-config.path;
          calendar = "04:00";
          retentionDays = 1;
        };
      };
    };
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
  time.timeZone = lib.mkForce "Europe/London";
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
      };

      netrc = {
        sopsFile = ../../secrets/netrc-bunker;
        format = "binary";
      };

      rclone-config = {
        sopsFile = ../../secrets/rclone-gdrive-andrewyazura-config;
        format = "binary";
        owner = "minecraft";
        group = "minecraft";
        mode = "0400";
      };
    };
  };

  services = {
    openssh = {
      enable = true;
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
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
    };
  };

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
    8443
  ];

  system.stateVersion = "25.11";
}
