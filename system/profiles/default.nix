{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.profiles;
in
{
  options.modules.profiles = {
    desktop.enable = mkEnableOption "Desktop system profile";
    gaming.enable = mkEnableOption "Gaming profile";
  };

  config = mkMerge [
    (mkIf cfg.desktop.enable {
      modules = {
        audio.enable = mkDefault true;
        fonts.enable = mkDefault true;
        networking.enable = mkDefault true;
        gui-apps = {
          base.enable = mkDefault true;
          communication.enable = mkDefault true;
          media.enable = mkDefault true;
          productivity.enable = mkDefault true;
        };
      };
    })

    (mkIf cfg.gaming.enable {
      modules.gui-apps.gaming.enable = mkDefault true;
    })
  ];
}
