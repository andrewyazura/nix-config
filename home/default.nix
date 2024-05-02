{ ... }:

{
  imports = [ ./programs ./neovim ./kitty ./sway ];

  home = {
    username = "andrew";
    homeDirectory = "/home/andrew";

    stateVersion = "23.11";
  };

  programs.home-manager.enable = true;
}
