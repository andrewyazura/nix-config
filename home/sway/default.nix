{ lib, config, ... }:
with lib;
let cfg = config.modules.sway;
in {
  options.modules.sway = {
    enable = mkEnableOption "Enable sway configuration";
    output = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      description = ''
        Forward params to wayland.windowManager.sway.config.output
      '';
    };
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
            xkb_options = "grp:win_space_toggle,caps:swapescape";
          };

          "12771:4898:Wooting_Wooting_60HE+" = {
            xkb_options = "grp:win_space_toggle";
          };

          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "0";
          };
        };

        output = cfg.output;

        focus = { followMouse = false; };
      };

      extraConfig = ''
        focus output DP-3
        for_window [instance="cs2" class="SDL Application"] fullscreen enable
      '';
    };
  };
}
