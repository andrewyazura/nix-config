{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [ mangohud ];

  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam.enable = true;
  };
}
