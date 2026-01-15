{ lib, config, ... }:
with lib;
let
  cfg = config.modules.gui-apps.media;
in
{
  options.modules.gui-apps.media = {
    enable = mkEnableOption "Enable media GUI applications (macOS)";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "spotify"
    ];
  };
}
