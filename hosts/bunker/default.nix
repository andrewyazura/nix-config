{ config, pkgs, ... }: {
  modules = {
    nix.enable = true;
    minecraft-server.enable = true;
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
  time.timeZone = "Europe/London";
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

    secrets."duty-reminder.env" = {
      sopsFile = ../../secrets/duty-reminder.env;
      format = "dotenv";

      owner = "duty-reminder";
      group = "duty-reminder";
      mode = "0400";
      restartUnits = [ "duty-reminder.service" ];
    };

    secrets."andrewyazura.crt" = {
      sopsFile = ../../secrets/andrewyazura.crt;
      format = "binary";

      owner = "nginx";
      group = "nginx";
      mode = "0400";
    };

    secrets."andrewyazura.key" = {
      sopsFile = ../../secrets/andrewyazura.key;
      format = "binary";

      owner = "nginx";
      group = "nginx";
      mode = "0400";
    };
  };

  services = {
    openssh = {
      enable = true;
      authorizedKeys.keys = import ../../common/ssh-keys.nix;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
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
      ensureDatabases = [ "duty_reminder" ];

      ensureUsers = [{
        name = "duty_reminder";
        ensureDBOwnership = true;
      }];
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 443 8443 ];

  system.stateVersion = "24.11";
}
