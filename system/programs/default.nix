{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    obsidian
    spotify
    vesktop # fixed screensharing
  ];
}
