{ pkgs, ...}: {
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
    waybar
    hyprlock
    hyprpaper
    dunst
  ];
}
