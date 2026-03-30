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
          ApplePressAndHoldEnabled = false;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
        };

        dock = {
          autohide = true;
          tilesize = 48; # default = 64
          orientation = "bottom";
          show-recents = false;

          # 1 = disabled
          wvous-bl-corner = 1;
          wvous-br-corner = 1;
          wvous-tl-corner = 1;
          wvous-tr-corner = 1;
        };

        finder = {
          AppleShowAllExtensions = true;
          AppleShowAllFiles = true;
        };

        menuExtraClock = {
          FlashDateSeparators = false;
          IsAnalog = false;
          Show24Hour = false;
          ShowDate = 2;
          ShowDayOfMonth = false;
          ShowDayOfWeek = false;
          ShowSeconds = false;
        };
      };
    };
  };
}
