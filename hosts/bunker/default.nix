{
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    ./disko-config.nix

    ../../users/andrew/system
    ../../users/andrew/system/bunker

    ./apps/birthday-api.nix
    ./apps/birthday-bot.nix
    ./apps/stresses-bot.nix
  ];

  modules = {
    nix.enable = true;

    minecraft-server = {
      enable = true;

      servers.bombas = {
        jvmOpts = "-Xms8192M -Xmx8192M";

        serverProperties = {
          server-port = 25565;
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
    auto-optimise-store = true;
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

  users.users.root.hashedPassword = "!";
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
    443
    8443
  ];

  system.stateVersion = "25.11";
}
