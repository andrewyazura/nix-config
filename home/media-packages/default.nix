{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.media-packages;
in
{
  options.modules.media-packages = {
    enable = mkEnableOption "Enable media CLI packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpv
    ];
  };
}
