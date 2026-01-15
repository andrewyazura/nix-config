{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.gui-apps.communication;
in
{
  options.modules.gui-apps.communication = {
    enable = mkEnableOption "Enable communication GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      discord
      vesktop
      signal-desktop
    ];
  };
}
