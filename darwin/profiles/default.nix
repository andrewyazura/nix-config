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
    desktop.enable = mkEnableOption "macOS desktop profile";
    development.enable = mkEnableOption "Development profile";
    gaming.enable = mkEnableOption "Gaming profile";
  };

  config = mkMerge [
    (mkIf cfg.desktop.enable {
      modules = {
        aerospace.enable = mkDefault true;
        desktop-apps.enable = mkDefault true;
        darwin-packages = {
          docker.enable = mkDefault true;
          gnuTools.enable = mkDefault true;
        };
        fonts.enable = mkDefault true;
        homebrew.enable = mkDefault true;
        karabiner.enable = mkDefault true;
        system-defaults.enable = mkDefault true;
        system-tools.enable = mkDefault true;
      };
    })

    (mkIf cfg.development.enable {
      modules = {
        development-apps.enable = mkDefault true;
      };
    })

    (mkIf cfg.gaming.enable {
      modules.gaming.enable = mkDefault true;
    })
  ];
}
