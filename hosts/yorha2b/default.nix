{ inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../users/andrew/system

    inputs.private-config.nixosModules.default
  ];

  modules = {
    audio.enable = true;
    fonts.enable = true;
    guitar.enable = true;
    networking.enable = true;
    nix.enable = true;
    programs = {
      enable = true;
      enableMinecraft = true;
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
      waybar.enable = true;
      sway = {
        enable = true;
        output = {
          DP-3 = {
            position = "0 0";
            mode = "3840x2160@144Hz";
          };

          HDMI-A-1 = {
            position = "3840 720";
            mode = "2560x1440@144Hz";
          };
        };

        focus-output = "HDMI-A-1";
      };
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
