{ lib, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ../../users/andrew/system ];

  modules = {
    minecraft-server.enable = true;
    nix.enable = true;
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
