{ lib, config, ... }:
with lib;
let cfg = config.modules.system-defaults;
in {
  options.modules.system-defaults = {
    enable = mkEnableOption "Enable macOS system defaults configuration";
  };

  config = mkIf cfg.enable {
    security.pam.services.sudo_local.touchIdAuth = true;

    system = {
      defaults = {
        ".GlobalPreferences"."com.apple.sound.beep.sound" =
          /System/Library/Sounds/Blow.aiff;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";

        dock = {
          autohide = true;
          show-recents = false;
          persistent-apps =
            [ "/Applications/Firefox.app" "/Applications/Ghostty.app" ];
        };
      };

      keyboard = {
        enableKeyMapping = true;
        swapLeftCtrlAndFn = true;
        remapCapsLockToEscape = true;
      };
    };
  };
}
