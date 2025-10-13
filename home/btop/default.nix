{ lib, config, ... }:
with lib;
let cfg = config.modules.btop;
in {
  options.modules.btop = {
    enable = mkEnableOption "Enable btop configuration";
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = "tokyo-night";
        theme_background = true;
        vim_keys = true;
      };
    };
  };
}

