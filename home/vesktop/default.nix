{ lib, config, ... }:
with lib;
let
  cfg = config.modules.vesktop;
in
{
  options.modules.vesktop = {
    enable = mkEnableOption "Enable Vesktop configuration";
  };

  config = mkIf cfg.enable {
    programs.vesktop = {
      enable = true;

      settings = {
        arRPC = true;
        audio.workaround = true;
        discordBranch = "stable";
        hardwareAcceleration = false;
        minimizeToTray = true;
        spellCheckLanguages = [
          "en-US"
          "en"
        ];
        splashBackground = "rgb(0, 0, 0)";
        splashColor = "rgb(220, 220, 223)";
      };
    };
  };
}
