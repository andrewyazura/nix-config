{ lib, config, hyprland, hyprland-plugins, pkgs, ... }:
with lib;
let
  cfg = config.modules.hyprland;
  hypr = hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  hypr-plugins = hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = hypr.hyprland;
      portalPackage = hypr.xdg-desktop-portal-hyprland;
      plugins = [ hypr-plugins.hyprbars ];
    };
  };
}
