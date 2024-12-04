{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mangohud
  ];

  programs = {
    gamescope = {
      enable = true;
    };

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
}
