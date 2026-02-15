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
  };

  config = mkIf cfg.desktop.enable {
    modules = {
      aerospace.enable = mkDefault true;
      fonts.enable = mkDefault true;
      homebrew.enable = mkDefault true;
      system-defaults.enable = mkDefault true;
      gui-apps = {
        base.enable = mkDefault true;
        communication.enable = mkDefault true;
        development.enable = mkDefault true;
        gaming.enable = mkDefault true;
        media.enable = mkDefault true;
        productivity.enable = mkDefault true;
        system-tools.enable = mkDefault true;
      };
      darwin-packages = {
        docker.enable = mkDefault true;
        gnuTools.enable = mkDefault true;
      };
    };
  };
}
