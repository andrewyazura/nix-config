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
      enableZshIntegration = true;

      settings = {
        background-opacity = 0.9;
        font-family = "Adwaita Mono Nerd Font";
        font-size = 10;
        shell-integration-features = [ "ssh-terminfo" "ssh-env" ];
        theme = "Catppuccin Mocha";
        window-decoration = "server";
        window-inherit-working-directory = false;
        window-theme = "ghostty";
        working-directory = "home";
      };
    };
  };
}
