{ inputs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../users/andrew/system

    inputs.private-config.nixosModules.default
  ];

  modules = {
    profiles = {
      desktop.enable = true;
      development.enable = true;
      gaming.enable = true;
    };

    sway.enable = true;
    wooting.enable = true;
    work.enable = true;
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
      ../../users/andrew/home/yorha2b

      inputs.private-config.homeManagerModules.default
    ];

    modules = {
      gnome.enable = true;
      waybar.enable = true;

      sway = {
        enable = true;
        output = {
          DP-3 = {
            position = "0 0";
            mode = "3840x2160@144Hz";
          };

          HDMI-A-1 = {
            position = "3840 360";
            mode = "2560x1440@144Hz";
          };
        };

        focus-output = "DP-3";
      };
    };
  };

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha2b_nixconfig_1510" ];
    secrets.netrc = {
      sopsFile = ../../secrets/netrc-yorha2b;
      format = "binary";
    };
  };

  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      configurationLimit = 10;
      gfxmodeEfi = "2560x1440";
    };

    efi.canTouchEfiVariables = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  time.timeZone = "Europe/Warsaw";

  system.stateVersion = "24.11";
}
