{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.ghostty;
  mock = pkgs.emptyDirectory // {
    meta = {
      mainProgram = "ghostty";
    };
  };
in
{
  options.modules.ghostty = {
    enable = mkEnableOption "Enable ghostty configuration";

    fontFamily = mkOption {
      type = types.str;
      default = "AdwaitaMono Nerd Font";
      description = "Ghostty font family";
    };

    fontSize = mkOption {
      type = types.int;
      default = 11;
      description = "Ghostty font size";
    };

    fontStyle = mkOption {
      type = types.str;
      default = "Regular";
      description = "Ghostty font style";
    };

    backgroundOpacity = mkOption {
      type = types.float;
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
        font-family = cfg.fontFamily;
        font-size = cfg.fontSize;
        font-style = cfg.fontStyle;
        shell-integration-features = [
          "ssh-terminfo"
          "ssh-env"
        ];
        theme = "Catppuccin Mocha";
        window-decoration = "server";
        window-inherit-working-directory = false;
        window-theme = "ghostty";
        working-directory = "home";
      };
    };
  };
}
