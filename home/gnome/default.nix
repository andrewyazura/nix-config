{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.gnome;
in
{
  options.modules.gnome = {
    enable = mkEnableOption "Enable gnome configuration";
  };

  config = mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            pop-shell.extensionUuid
          ];
        };

        "org/gnome/desktop/wm/keybindings" = {
          minimize = [ ];
        };
      };
    };
  };
}
