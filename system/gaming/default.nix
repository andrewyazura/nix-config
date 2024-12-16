{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mangohud
  ];

  programs = {
    gamescope.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  # my launch options for most games:
  # LD_PRELOAD="" mangohud gamescope --force-grab-cursor -H 1440 -f -- %command%

  # for cyberpunk 2077:
  # LD_PRELOAD="" mangohud gamescope --force-grab-cursor -h 900 -H 1440 -F fsr -f -- %command% --launcher-skip
}
