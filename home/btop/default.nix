{ lib, config, ... }:
with lib;
let
  cfg = config.modules.btop;
in
{
  options.modules.btop = {
    enable = mkEnableOption "Enable btop configuration";
  };

  config = mkIf cfg.enable {
    catppuccin.btop.enable = true;

    programs.btop = {
      enable = true;
      settings = {
        theme_background = true;
        vim_keys = true;
      };
    };
  };
}
