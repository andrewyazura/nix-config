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
  imports = [ inputs.sysc-greet.nixosModules.default ];

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
      config.common.default = [ "gtk" ];
      xdgOpenUsePortal = true;
    };

    services = {
      playerctld.enable = true;

      sysc-greet = {
        enable = true;
        compositor = "hyprland";
        hyprlandPackage = hyprlandPkgs.hyprland;
      };
    };

    systemd.services.greetd = {
      serviceConfig.Type = "idle";
      unitConfig.After = mkForce [ "multi-user.target" ];
    };

    console = {
      colors = map (removePrefix "#") (import ../../common/ansi.nix);
      font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
      earlySetup = true;
    };

    security.pam.services.hyprlock = { };
  };
}
