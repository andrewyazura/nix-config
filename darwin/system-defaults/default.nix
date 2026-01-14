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

    launchd.user.agents =
      let
        escape = "0x700000029";
        capsLock = "0x700000039";

        fn = "0xFF00000003";
        leftCtrl = "0x7000000E0";
        leftOption = "0x7000000E2";
        leftCommand = "0x7000000E3";
      in
      {
        KeyMappingsBuiltin = {
          serviceConfig = {
            Label = "com.local.KeyMappingsBuiltin";
            RunAtLoad = true;
            LaunchEvents = {
              "com.apple.notifyd.matching" = {
                "com.local.KeyMappingsBuiltin.wake" = {
                  Notification = "com.apple.screenIsUnlocked";
                };
              };
            };

            ProgramArguments = [
              "/usr/bin/hidutil"
              "property"
              "--set"
              ''
                {"UserKeyMapping":[
                    {
                      "HIDKeyboardModifierMappingSrc": ${escape},
                      "HIDKeyboardModifierMappingDst": ${capsLock}
                    },

                    {
                      "HIDKeyboardModifierMappingSrc": ${capsLock},
                      "HIDKeyboardModifierMappingDst": ${escape}
                    },

                    {
                      "HIDKeyboardModifierMappingSrc": ${fn},
                      "HIDKeyboardModifierMappingDst": ${leftCtrl}
                    },

                    {
                      "HIDKeyboardModifierMappingSrc": ${leftCtrl},
                      "HIDKeyboardModifierMappingDst": ${fn}
                    }
                ]}''
            ];
          };
        };

        KeyMappingsWooting = {
          serviceConfig = {
            Label = "com.local.KeyMappingsWooting";
            RunAtLoad = true;
            LaunchEvents = {
              "com.apple.iokit.matching" = {
                "com.apple.device-attach" = {
                  "idVendor" = 12771;
                };
              };
            };

            ProgramArguments = [
              "/usr/bin/hidutil"
              "property"
              "--matching"
              ''{ "VendorID": 12771 }''
              "--set"
              ''
                {"UserKeyMapping":[
                    {
                      "HIDKeyboardModifierMappingSrc": ${leftOption},
                      "HIDKeyboardModifierMappingDst": ${leftCommand}
                    },

                    {
                      "HIDKeyboardModifierMappingSrc": ${leftCommand},
                      "HIDKeyboardModifierMappingDst": ${leftOption}
                    },

                    {
                      "HIDKeyboardModifierMappingSrc": ${leftCtrl},
                      "HIDKeyboardModifierMappingDst": ${leftCtrl}
                    }
                ]}''
            ];
          };
        };
      };
  };
}
