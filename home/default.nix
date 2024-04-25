{ config, pkgs, ... }:

{
  imports = [ ./programs ./i3 ./polybar ./neovim ./kitty ];

  home = {
    username = "andrew";
    homeDirectory = "/home/andrew";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
