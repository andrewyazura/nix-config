{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.packages.media;
in
{
  options.modules.packages.media = {
    enable = mkEnableOption "Enable media CLI packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpv
    ];
  };
}
