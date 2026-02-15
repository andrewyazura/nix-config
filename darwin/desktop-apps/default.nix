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
      "bitwarden"
      "firefox"
      "ghostty"
      "google-chrome"

      "discord"
      "signal"
      "slack"
      "telegram"

      "spotify"

      "claude"
      "obsidian"
    ];
  };
}
