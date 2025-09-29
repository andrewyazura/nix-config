{ lib, config, ... }:
with lib;
let cfg = config.modules.gnome;
in {
  options.modules.gnome = {
    enable = mkEnableOption "Enable GNOME configuration";
  };

  config = mkIf cfg.enable {
    services = {
      xserver.enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };
}
