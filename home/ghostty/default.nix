{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.ghostty;
  mock = pkgs.emptyDirectory // { meta = { mainProgram = "ghostty"; }; };
in {
  options.modules.ghostty = {
    enable = mkEnableOption "Enable ghostty configuration";
    fontSize = mkOption {
      type = lib.types.int;
      default = 9;
      description = "Ghostty font size";
    };
    backgroundOpacity = mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Ghostty background opacity";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      package = if pkgs.stdenv.isDarwin then mock else pkgs.ghostty;

      settings = {
        background-opacity = cfg.backgroundOpacity;
        font-family = "Adwaita Mono Nerd Font";
        font-size = cfg.fontSize;
        shell-integration-features = [ "ssh-terminfo" "ssh-env" ];
        theme = "Catppuccin Latte";
        window-decoration = "server";
        window-inherit-working-directory = false;
        window-theme = "ghostty";
        working-directory = "home";
      };
    };
  };
}
