{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.gui-apps.media;
in
{
  options.modules.gui-apps.media = {
    enable = mkEnableOption "Enable media GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      spotify
      obs-studio
    ];
  };
}
