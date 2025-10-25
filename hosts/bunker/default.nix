{ config, lib, pkgs, ... }: {
  imports = [ ../../users/andrew/system ../../users/andrew/system/bunker ];

  modules = {
    nix.enable = true;
    minecraft-server.enable = true;
  };

  home-manager.users.andrew = {
    imports = [ ../../home ../../users/andrew/home ];
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
  };

  environment.systemPackages = with pkgs; [ vim git ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "ext4";
  };
  swapDevices = [{ device = "/dev/disk/by-label/swap"; }];

  documentation.nixos.enable = false;
  time.timeZone = lib.mkForce "Europe/London";
  console.keyMap = "us";

  boot = {
    loader.grub.enable = true;
    loader.grub.device = "/dev/sda";
    initrd.availableKernelModules =
      [ "ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sd_mod" "sr_mod" "ext4" ];
  };

  users.users.root.hashedPassword = "!";

  security.sudo.wheelNeedsPassword = false;
  programs.dconf.enable = true;

  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      "duty-reminder.env" = {
        sopsFile = ../../secrets/duty-reminder.env;
        format = "dotenv";

        owner = "duty-reminder";
        group = "duty-reminder";
        mode = "0400";
        restartUnits = [ "duty-reminder.service" ];
      };

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

    birthday-api = {
      enable = true;
      configFile = "/var/lib/birthday-api/config.ini";
    };

    birthday-bot = {
      enable = true;
      configFile = "/var/lib/birthday-bot/config.ini";
    };

    duty-reminder = {
      enable = true;
      environment = { SERVER_PORT = "10000"; };
      environmentFile = config.sops.secrets."duty-reminder.env".path;
    };

    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      virtualHosts."duty-reminder.andrewyazura.com" = {
        forceSSL = true;
        sslCertificate = config.sops.secrets."andrewyazura.crt".path;
        sslCertificateKey = config.sops.secrets."andrewyazura.key".path;

        locations."/" = { proxyPass = "http://127.0.0.1:10000"; };
      };
    };

    postgresql = {
      enable = true;
      package = pkgs.postgresql_16;
      ensureDatabases = [ "birthday_api" "duty_reminder" ];

      ensureUsers = [
        {
          name = "birthday_api";
          ensureDBOwnership = true;
        }
        {
          name = "duty_reminder";
          ensureDBOwnership = true;
        }
      ];
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 443 8443 ];

  system.stateVersion = "24.11";
}
