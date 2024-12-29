{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    obsidian
    spotify
    telegram-desktop
    vesktop # fixed screensharing
  ];
}
