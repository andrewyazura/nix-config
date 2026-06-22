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
      "ankerwork"
      "bitwarden"
      "claude"
      "discord"
      "ghostty"
      "google-chrome"
      "hiddenbar"
      "mp3tag"
      "obs"
      "obsidian"
      "signal"
      "slack"
      "spotify"
      "stats"
      "termius"
    ];
  };
}
