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
        background-opacity = 0.9;
        font-family = "FiraCode Nerd Font Mono";
        font-size = 10;
        theme = "Catppuccin Mocha";
        window-decoration = "server";
        window-inherit-working-directory = false;
        window-theme = "ghostty";
        working-directory = "home";
      };
    };
  };
}
