{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.i3;
in {
  options.modules.i3 = { enable = mkEnableOption "Enable i3 configuration"; };

  config = mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        modifier = "Mod4";
        terminal = "ghostty";

        keybindings = {
          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+d" = "exec dmenu_run";
        };

        focus = { followMouse = false; };
      };
    };
  };
}
