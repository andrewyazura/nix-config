{ pkgs, ... }: {
  environment.systemPackages = [ pkgs.mangohud ];

  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam.enable = true;
  };
}
