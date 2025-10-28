{
  imports = [ ./hardware-configuration.nix ../../users/andrew/system ];

  modules = {
    audio.enable = true;
    fonts.enable = true;
    i3.enable = true;
    networking.enable = true;
    nix.enable = true;
    programs.enable = true;
    work.enable = true;
  };

  home-manager.users.andrew = {
    imports =
      [ ../../home ../../users/andrew/home ../../users/andrew/home/yorha9s ];

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
    supergfxd.enable = true;
    asusd = { enable = true; };

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

  time.timeZone = "Europe/Warsaw";

  system.stateVersion = "24.11";
}
