{ lib, config, ... }:
with lib;
let
  cfg = config.modules.karabiner;
in
{
  options.modules.karabiner = {
    enable = mkEnableOption "Enable karabiner-elements configuration";
  };

  config = mkIf cfg.enable {
    home.file.".config/karabiner/karabiner.json".text =
      let

        builtInKeyboard = {
          type = "device_if";
          identifiers = [ { is_built_in_keyboard = true; } ];
        };

        wootingKeyboard = {
          type = "device_if";
          identifiers = [ { vendor_id = 12771; } ];
        };
      in
      builtins.toJSON {
        profiles = [
          {
            name = "Default profile";
            selected = true;

            complex_modifications = {
              rules = [
                {
                  description = "Internal Keyboard: Swap Caps/Esc and Fn/Ctrl";
                  manipulators = [
                    {
                      description = "Caps Lock to Escape";
                      type = "basic";
                      from = {
                        key_code = "caps_lock";
                      };
                      to = [ { key_code = "escape"; } ];
                      conditions = [ builtInKeyboard ];
                    }
                    {
                      description = "Escape to Caps Lock";
                      type = "basic";
                      from = {
                        key_code = "escape";
                      };
                      to = [ { key_code = "caps_lock"; } ];
                      conditions = [ builtInKeyboard ];
                    }
                    {
                      description = "Fn to Left Ctrl";
                      type = "basic";
                      from = {
                        apple_vendor_top_bar_key_code = "fn";
                      };
                      to = [ { key_code = "left_control"; } ];
                      conditions = [ builtInKeyboard ];
                    }
                    {
                      description = "Left Ctrl to Fn";
                      type = "basic";
                      from = {
                        key_code = "left_control";
                      };
                      to = [ { apple_vendor_top_bar_key_code = "fn"; } ];
                      conditions = [ builtInKeyboard ];
                    }
                  ];
                }
                {
                  description = "Wooting: Swap Option and Command";
                  manipulators = [
                    {
                      type = "basic";
                      from = {
                        key_code = "left_option";
                      };
                      to = [ { key_code = "left_command"; } ];
                      conditions = [ wootingKeyboard ];
                    }
                    {
                      type = "basic";
                      from = {
                        key_code = "left_command";
                      };
                      to = [ { key_code = "left_option"; } ];
                      conditions = [ wootingKeyboard ];
                    }
                  ];
                }
              ];
            };

            devices = [
              {
                identifiers = {
                  is_built_in_keyboard = true;
                  is_keyboard = true;
                };
                disable_built_in_keyboard_if_exists = false;
              }
            ];
          }
        ];
      };
  };
}
