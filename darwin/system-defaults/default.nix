{ lib, config, ... }:
with lib;
let cfg = config.modules.system-defaults;
in {
  options.modules.system-defaults = {
    enable = mkEnableOption "Enable macOS system defaults configuration";
  };

  config = mkIf cfg.enable {
    security.pam.services.sudo_local.touchIdAuth = true;

    system.defaults = {
      dock = {
        autohide = true;
        show-recents = false;
      };
    };

    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
  };
}
