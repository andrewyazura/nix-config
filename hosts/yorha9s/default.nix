{ inputs, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../users/andrew/system

    inputs.private-config.nixosModules.default
  ];

  modules = {
    audio.enable = true;
    fonts.enable = true;
    i3.enable = true;
    networking.enable = true;
    nix.enable = true;
    work.enable = true;

    programs = {
      enable = true;
      enableMinecraft = true;
    };
  };

  home-manager.users.andrew = {
    imports = [
      ../../home
      ../../users/andrew/home
      ../../users/andrew/home/yorha9s

      inputs.private-config.homeManagerModules.default
    ];

    modules = {
      i3.enable = true;
      polybar.enable = true;
    };
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  services = {
    asusd.enable = true;
    supergfxd.enable = true;
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
          Identifier "disable swapescape for wooting 60he+"
          MatchProduct "Wooting Wooting 60HE+"
          Option "XkbLayout" "${layouts}"
          Option "XkbOptions" "grp:win_space_toggle"
        ''
        ''
          Identifier "disable swapescape for glorious gmmk compact"
          MatchProduct "SONIX USB DEVICE"
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

  time.timeZone = "Europe/Kyiv";

  system.stateVersion = "24.11";
}
