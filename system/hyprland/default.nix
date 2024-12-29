{ pkgs, ... }: {
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    dunst
    hyprlock
    hyprpaper
    kitty
    tofi
    waybar
  ];
}
