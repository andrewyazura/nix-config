{ pkgs, ... }: {
  security.polkit.enable = true;
  users.users.andrew.extraGroups = [ "video" ];

  services = {
    displayManager = { defaultSession = "sway"; };

    xserver.enable = false;
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  programs.light.enable = true;

  environment.systemPackages = with pkgs; [ grim slurp wl-clipboard mako ];
}
