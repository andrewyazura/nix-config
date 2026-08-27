{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.ghostty;
  colors = import ../../common/colors.nix;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
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
      default = "JetBrainsMono Nerd Font";
      description = "Ghostty font family";
    };

    fontSize = mkOption {
      type = types.int;
      default = 12;
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
      package = if isDarwin then mock else pkgs.ghostty;

      settings = {
        background = colors.bg;
        foreground = colors.text;
        cursor-color = colors.accent;
        cursor-text = colors.bg;
        selection-background = colors.overlay;
        selection-foreground = colors.bright;

        palette = [
          "0=${colors.overlay}"
          "1=${colors.red}"
          "2=${colors.green}"
          "3=${colors.yellow}"
          "4=${colors.blue}"
          "5=${colors.accent}"
          "6=${colors.teal}"
          "7=${colors.text}"
          "8=${colors.muted}"
          "9=${colors.pink}"
          "10=${colors.green}"
          "11=${colors.yellow}"
          "12=${colors.indigo}"
          "13=${colors.accent}"
          "14=${colors.accentAlt}"
          "15=${colors.bright}"
        ];

        background-opacity = cfg.backgroundOpacity;
        font-family = cfg.fontFamily;
        font-size = cfg.fontSize;
        font-style = cfg.fontStyle;
        shell-integration-features = [
          "ssh-terminfo"
          "ssh-env"
        ];
        window-decoration = "server";
      };
    };
  };
}
