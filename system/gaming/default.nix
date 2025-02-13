{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mangohud
    (lutris.override { })
  ];

  programs = {
    gamemode.enable = true;
    gamescope.enable = true;
    steam.enable = true;
  };
}
