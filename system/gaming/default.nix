{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ mangohud ];

  programs = {
    gamescope = {
      enable = true;
      capSysNice = true;
    };

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };

  # my launch options for most games:
  # LD_PRELOAD="" mangohud gamescope --force-grab-cursor -H 1440 -f -- %command%
}
