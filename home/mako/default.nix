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
        margin = "0,10,10";
        padding = 12;
        width = 380;
        height = 160;
        default-timeout = 5000;

        font = "Noto Sans CJK JP 11";
        background-color = colors.bg;
        text-color = colors.text;
        border-color = colors.text;
        border-size = 1;
        border-radius = 0;
        progress-color = "over ${colors.raised}";

        icons = true;
        max-icon-size = 48;
        format = "<span color='${colors.subtle}'>%a</span>\\n<b>%s</b>\\n%b";

        "urgency=low".text-color = colors.subtle;

        "urgency=critical" = {
          border-color = colors.red;
          default-timeout = 0;
        };
      };
    };
  };
}
