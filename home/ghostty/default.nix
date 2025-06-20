{ lib, config, ... }:
with lib;
let cfg = config.modules.ghostty;
in {
  options.modules.ghostty = {
    enable = mkEnableOption "Enable ghostty configuration";
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        background-opacity = 1;
        font-size = 9;
        font-family = "FiraCode Nerd Font Mono";
        theme = "catppuccin-mocha";
        window-decoration = "none";
      };
    };
  };
}
