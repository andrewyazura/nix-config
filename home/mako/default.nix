{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.mako;
  colors = import ../../common/colors.nix;
in
{
  options.modules.mako = {
    enable = mkEnableOption "Enable mako notification daemon";
  };

  config = mkIf cfg.enable {
    services.mako = {
      enable = true;
      settings = {
        anchor = "top-right";
        layer = "overlay";
        margin = 8;
        padding = 12;
        width = 380;
        height = 160;
        default-timeout = 5000;

        font = "Inter 11";
        background-color = "${colors.surface}e6";
        text-color = colors.text;
        border-color = colors.overlay;
        border-size = 1;
        border-radius = 10;
        progress-color = "over ${colors.accent}";

        icons = true;
        max-icon-size = 48;
        format = "<b>%s</b>\\n%b";

        "urgency=low".text-color = colors.subtle;

        "urgency=critical" = {
          border-color = colors.red;
          default-timeout = 0;
        };
      };
    };
  };
}
