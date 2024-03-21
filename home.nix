{ config, pkgs, ... }:

{
  home.username = "andrew";
  home.homeDirectory = "/home/andrew";

  home.packages = with pkgs; [
    neofetch

    # archives
    zip
    unzip

    # utils
    ripgrep

    # misc
    cowsay
    which
    tree

    # system
    pciutils
    usbutils
    lshw

    vscode
    telegram-desktop
    discord
    firefox
    thunderbird
    spotify
  ];

  programs.git = {
    enable = true;
    userName = "Andrew Yatsura";
    userEmail = "andrewyazura203@proton.me";
  };

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
}
