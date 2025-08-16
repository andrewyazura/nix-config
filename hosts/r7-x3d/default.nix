{ username, ... }: {
  imports = [
    ../../system

    ./hardware-configuration.nix
  ];

  modules = {
    audio.enable = true;
    fonts.enable = true;
    gaming.enable = true;
    guitar.enable = true;
    networking.enable = true;
    nix.enable = true;
    programs.enable = true;
    sway.enable = true;
    wooting.enable = true;
  };

  home-manager.users.${username}.modules = {
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

      focus-output = "HDMI-A-1";
    };

    waybar = {
      enable = false;
      output = [ "HDMI-A-1" ];
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
