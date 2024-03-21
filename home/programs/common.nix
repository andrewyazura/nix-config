{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    zip
    unzip

    ripgrep

    cowsay
    which
    tree
    neofetch

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

  programs = {
    git = {
      enable = true;
      userName = "Andrew Yatsura";
      userEmail = "andrewyazura203@proton.me";
    };
  };
}
