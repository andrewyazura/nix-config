{ config, pkgs, ... }:

{
  imports = [ ./programs ./neovim ./kitty ./hyprland ];

  home = {
    username = "andrew";
    homeDirectory = "/home/andrew";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
