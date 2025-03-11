{ lib, config, ... }:
with lib;
let cfg = config.modules.hyprland;
in {
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf cfg.enable {
    home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;
  };
}
