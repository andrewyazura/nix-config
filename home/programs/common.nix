{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    beeper
    chromium
    cowsay
    discord
    firefox
    insomnia
    kitty
    lshw
    neofetch
    obsidian
    oh-my-zsh
    pciutils
    ripgrep
    spotify
    telegram-desktop
    thunderbird
    tree
    unzip
    usbutils
    vscode
    which
    zip
    zsh
  ];
}
