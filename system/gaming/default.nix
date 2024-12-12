{ pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    mangohud
    oversteer
    usb-modeswitch # for oversteer
  ];

  programs = {
    gamescope.enable = true;

    steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
  };
}
