{ lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../users/andrew/system ];

  modules = {
    minecraft-server = {
      enable = true;
      servers.bombas = {
        jvmOpts = "-Xms8192M -Xmx8192M";

        serverProperties = { server-port = 25567; };
      };
    };
    nix.enable = true;
  };

  home-manager.users.andrew = {
    imports = [ ../../home ../../users/andrew/home ];

    home.stateVersion = "24.11";
  };

  nix.settings = {
    auto-optimise-store = true;
    trusted-users = [ "@wheel" ];
  };

  environment.systemPackages = with pkgs; [ vim git ];

  documentation.nixos.enable = false;
  time.timeZone = lib.mkForce "Europe/London";
  console.keyMap = "us";

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  users.users = {
    root.hashedPassword = "!";

    andrew = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDL7Ic9fNr9wAcgDMa66pbQlzmf9io1Lw2k6IOtv8Axd andrew@yorha2b"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOmSzNTOSzgu5Zm4/n2T4Z0ygJ8QLF+MG68p9CvfWINl andrew@yorha9s"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC/i3BbIxWxD0sjuR6aMvSwSyy6hBBxiw37kqR++/Tpm andrew@yorhaA2"
      ];
    };

    yaroslav = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWEorstb+zss69piBaqSnRyzLboRrKocxS0Nql9aIvH Hetzner"
      ];
    };
  };

  security.sudo.wheelNeedsPassword = false;
  programs = {
    dconf.enable = true;
    htop.enable = true;
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

    qemuGuest.enable = true;
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [ 22 443 8443 ];
  };

  system.stateVersion = "25.05";
}
