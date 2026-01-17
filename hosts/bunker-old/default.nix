{
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ../../users/andrew/system
    ../../users/andrew/system/bunker-old
  ];

  modules = {
    nix.enable = true;
    minecraft-server = {
      enable = true;
      servers.bombas = {
        jvmOpts = "-Xms3072M -Xmx3072M";

        serverProperties = {
          server-port = 25567;
        };
      };
    };
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
    ];

    home.stateVersion = "24.11";
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  documentation.nixos.enable = false;
  time.timeZone = lib.mkForce "Europe/London";
  console.keyMap = "us";

  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "virtio_pci"
      "virtio_scsi"
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

  system.stateVersion = "24.11";
}
