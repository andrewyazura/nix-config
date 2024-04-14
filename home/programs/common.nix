{ lib, pkgs, ... }: {
  home.packages = with pkgs; [
    chromium
    cowsay
    discord
    firefox
    flameshot
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
