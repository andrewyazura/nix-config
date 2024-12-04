{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    discord
    kitty
    obsidian
    spotify
  ];
}
