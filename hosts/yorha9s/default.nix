{
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/andrew/system

    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401
    inputs.private-config.nixosModules.default
  ];

  modules = {
    profiles = {
      desktop.enable = true;
      development.enable = true;
      gaming.enable = true;
    };

    hyprland.enable = true;
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
      ../../users/andrew/home/yorha9s

      inputs.private-config.homeManagerModules.default
    ];

    modules = {
      mako.enable = true;

      waybar = {
        enable = true;
        battery.enable = true;
      };

      hyprland = {
        enable = true;
        output = [
          {
            output = "eDP-1";
            mode = "1920x1080@144";
            position = "0x0";
          }
        ];
      };
    };
  };

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha9s_nixconfig_1510" ];
    secrets.netrc = {
      sopsFile = ../../secrets/netrc-yorha9s;
      format = "binary";
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services = {
    asusd.enable = true;
    supergfxd.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
  };

  hardware = {
    graphics.enable = true;
    nvidia.dynamicBoost.enable = false;
  };

  zramSwap.enable = true;

  time.timeZone = "Europe/Warsaw";

  system.stateVersion = "24.11";
}
