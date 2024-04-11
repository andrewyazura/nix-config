{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    zsh
    oh-my-zsh

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
    insomnia
    obsidian
    kitty
    spotify

    beeper
    telegram-desktop
    discord

    firefox
    thunderbird
    chromium
  ];
}
