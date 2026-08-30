{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.video-editing;
in
{
  options.modules.video-editing = {
    enable = mkEnableOption "Enable video editing tools";
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.kdePackages.kdenlive
    ];
  };
}
