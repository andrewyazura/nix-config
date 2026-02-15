{ lib, config, ... }:
with lib;
let
  cfg = config.modules.system-defaults;
in
{
  options.modules.system-defaults = {
    enable = mkEnableOption "Enable macOS system defaults configuration";
  };

  config = mkIf cfg.enable {
    security.pam.services.sudo_local = {
      enable = true;
      reattach = true;
      touchIdAuth = true;
    };

    system = {
      defaults = {
        ".GlobalPreferences" = {
          "com.apple.sound.beep.sound" = "/System/Library/Sounds/Blow.aiff";
        };

        NSGlobalDomain = {
          ApplePressAndHoldEnabled = true;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
        };

        dock = {
          autohide = true;
          orientation = "bottom";
          show-recents = true;
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
        };

        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
        };

        menuExtraClock = {
          FlashDateSeparators = false;
          IsAnalog = false;
          Show24Hour = true;
          ShowDate = 1;
          ShowDayOfMonth = true;
          ShowDayOfWeek = true;
          ShowSeconds = true;
        };
      };
    };
  };
}
