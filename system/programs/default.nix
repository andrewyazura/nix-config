{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    obsidian
    ripgrep
    spotify
    telegram-desktop
    vesktop # fixed screensharing
    wl-clipboard
  ];
}
