{ lib, config, ... }:
with lib;
let cfg = config.modules.system-defaults;
in {
  options.modules.system-defaults = {
    enable = mkEnableOption "Enable macOS system defaults configuration";

    touchIdForSudo = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Touch ID for sudo authentication";
    };

    dock = {
      autohide = mkOption {
        type = types.bool;
        default = true;
        description = "Automatically hide the dock";
      };

      showRecents = mkOption {
        type = types.bool;
        default = false;
        description = "Show recent applications in the dock";
      };
    };

    keyboard = {
      remapCapsLockToEscape = mkOption {
        type = types.bool;
        default = true;
        description = "Remap Caps Lock to Escape";
      };

      swapLeftCtrlAndFn = mkOption {
        type = types.bool;
        default = false;
        description = "Swap left Control and Fn keys";
      };
    };
  };

  config = mkIf cfg.enable {
    security.pam.services.sudo_local.touchIdAuth = cfg.touchIdForSudo;

    system.defaults = {
      dock = {
        autohide = cfg.dock.autohide;
        show-recents = cfg.dock.showRecents;
      };
    };

    system.keyboard = mkIf
      (cfg.keyboard.remapCapsLockToEscape || cfg.keyboard.swapLeftCtrlAndFn) {
        enableKeyMapping = true;
        remapCapsLockToEscape = cfg.keyboard.remapCapsLockToEscape;
        swapLeftCtrlAndFn = cfg.keyboard.swapLeftCtrlAndFn;
      };
  };
}
