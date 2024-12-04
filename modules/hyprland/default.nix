{ pkgs, ...}: {
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
    wofi
    dunst
    waybar
    hyprlock
    hyprpaper
  ];
}
