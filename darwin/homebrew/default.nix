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
        autoUpdate = true;
        cleanup = "zap";
      };

      casks = [
        "bitwarden"
        "discord"
        "firefox"
        "focusrite-control-2"
        "ghostty"
        "google-chrome"
        "obsidian"
        "signal"
        "slack"
        "spotify"
        "steam"
        "wootility"
      ];
    };
  };
}
