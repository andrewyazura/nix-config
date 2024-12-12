{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    obsidian
    ripgrep
    spotify
    vesktop # fixed screensharing
    wl-clipboard
  ];
}
