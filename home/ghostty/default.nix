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
      description = "Terminal font size";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      package = if pkgs.stdenv.isDarwin then mock else pkgs.ghostty;

      settings = {
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
