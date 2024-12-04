{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    kitty
    spotify
    obsidian
  ];
}
