{ lib, config, ... }:
with lib;
let
  cfg = config.modules.gui-apps.base;
in
{
  options.modules.gui-apps.base = {
    enable = mkEnableOption "Enable base GUI applications (macOS)";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "firefox"
      "google-chrome"
      "bitwarden"
      "ghostty"
    ];
  };
}
