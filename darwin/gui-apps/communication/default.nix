{ lib, config, ... }:
with lib;
let
  cfg = config.modules.gui-apps.communication;
in
{
  options.modules.gui-apps.communication = {
    enable = mkEnableOption "Enable communication GUI applications (macOS)";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "discord"
      "slack"
      "signal"
    ];
  };
}
