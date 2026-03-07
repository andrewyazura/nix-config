{ lib, config, ... }:
with lib;
let
  cfg = config.modules.desktop-apps;
in
{
  options.modules.desktop-apps = {
    enable = mkEnableOption "Enable desktop GUI applications (macOS)";
  };

  config = mkIf cfg.enable {
    homebrew.casks = [
      "ankerwork"
      "ghostty"
      "google-chrome"
      "obsidian"
      "signal"
      "slack"
      "spotify"
      "telegram"
      "vesktop"
    ];
  };
}
