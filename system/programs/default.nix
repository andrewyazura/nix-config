{ pkgs, inputs, ... }: {
  environment.systemPackages = with pkgs; [
    inputs.ghostty.packages.x86_64-linux.default
    obsidian
    spotify
    telegram-desktop
    vesktop # fixed screensharing

    tree
    neofetch
    nixfmt

    ffmpeg
    git-crypt
  ];
}
