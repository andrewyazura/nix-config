{ lib, config, ... }:
with lib;
let cfg = config.modules.gnome;
in {
  options.modules.gnome = {
    enable = mkEnableOption "Enable gnome configuration";
  };

  config = mkIf cfg.enable {
    dconf.settings."org/gnome/desktop/wm/keybindings" = { minimize = [ ]; };
  };
}
