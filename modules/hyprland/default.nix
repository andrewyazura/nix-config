{ pkgs, ...}: {
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    kitty
    tofi
    dunst
    waybar
    hyprlock
    hyprpaper
  ];
}
