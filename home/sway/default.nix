{ lib, config, ... }:
with lib;
let cfg = config.modules.sway;
in {
  options.modules.sway = {
    enable = mkEnableOption "Enable sway configuration";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod4";
        terminal = "ghostty";

        input = {
          "type:keyboard" = {
            xkb_layout = "us,ua";
            xkb_options = "grp:win_space_toggle,caps:escape";
          };

          "12771:4898:Wooting_Wooting_60HE+" = {
            xkb_options = "grp:win_space_toggle";
          };

          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "0";
          };
        };

        output = {
          DP-3 = {
            position = "0 0";
            mode = "3840x2160@144Hz";
          };

          HDMI-A-1 = {
            position = "3840 0";
            mode = "2560x1440@144Hz";
            transform = "90";
          };
        };

        focus = { followMouse = false; };
      };

      extraConfig = ''
        focus output DP-3
      '';
    };
  };
}
