{ lib, config, ... }:
with lib;
let cfg = config.modules.homebrew;
in {
  options.modules.homebrew = {
    enable = mkEnableOption "Enable homebrew configuration";
  };

  config = mkIf cfg.enable {
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false;
        cleanup = "zap";
      };

      casks = [
        "bitwarden"
        "discord"
        "firefox"
        "ghostty"
        "google-chrome"
        "obsidian"
        "signal"
        "slack"
        "sol"
        "spotify"
        "wootility"
      ];
    };
  };
}
