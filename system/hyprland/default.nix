{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf cfg.enable {
    programs.hyprland.enable = true;
    environment.systemPackages = with pkgs; [
      dunst
      hyprlock
      hyprpaper
      kitty
      tofi
      waybar
    ];
  };
}
