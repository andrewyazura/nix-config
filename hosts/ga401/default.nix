{ username, ... }: {
  imports = [
    ../../system

    ./hardware-configuration.nix
  ];

  modules = {
    audio.enable = true;
    fonts.enable = true;
    i3.enable = true;
    networking.enable = true;
    nix.enable = true;
    programs.enable = true;
    work.enable = true;
  };

  home-manager.users.${username}.modules = {
    gnome = {
      enable = false;
      enablePopShell = true;
    };
    i3.enable = true;
    polybar.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    libinput.touchpad.naturalScrolling = true;

    xserver = {
      videoDrivers = [ "nvidia" ];

      inputClassSections = let layouts = "us,ua";
      in [
        ''
          Identifier "general keyboard settings"
          MatchIsKeyboard "on"
          Option "XkbLayout" "${layouts}"
          Option "XkbOptions" "grp:win_space_toggle,caps:swapescape"
        ''
        ''
          Identifier "disable swapescape for wooting"
          MatchProduct "Wooting Wooting 60HE+"
          Option "XkbLayout" "${layouts}"
          Option "XkbOptions" "grp:win_space_toggle"
        ''
      ];
    };
  };

  hardware = {
    graphics.enable = true;
    nvidia.dynamicBoost.enable = false;
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
