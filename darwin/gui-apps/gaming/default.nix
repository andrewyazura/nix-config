{ lib, config, ... }:
with lib;
let
  cfg = config.modules.gui-apps.gaming;
in
{
  options.modules.gui-apps.gaming = {
    enable = mkEnableOption "Enable gaming GUI applications (macOS)";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "steam"
      "prismlauncher"
    ];
  };
}
