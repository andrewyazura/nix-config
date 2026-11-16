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
      "1password"
      "anki"
      "antigravity"
      "betterdisplay"
      "crmne/tap/spotifast"
      "discord"
      "ghostty"
      "google-chrome"
      "moonlight"
      "signal"
      "slack"
      "spotify"
      "telegram"
    ];
  };
}
