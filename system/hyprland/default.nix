{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.hyprland;
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkgs = inputs.hyprland.packages.${system};
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      config.common = {
        default = [ "gtk" ];
        "org.freedesktop.impl.portal.Secret" = [ "none" ];
      };
    };

    services = {
      oo7.enable = true;
      playerctld.enable = true;

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet -r --time --cmd start-hyprland";
          };
        };
      };
    };

    systemd.services.greetd = {
      serviceConfig.Type = "idle";
      unitConfig.After = mkForce [ "multi-user.target" ];
    };

    systemd.user.services.oo7-daemon.serviceConfig.MemorySwapMax = 0;

    security.pam.services.hyprlock = { };
  };
}
