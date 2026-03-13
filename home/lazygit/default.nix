{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.lazygit;
in
{
  options.modules.lazygit = {
    enable = mkEnableOption "Enable lazygit configuration";
  };

  config = mkIf cfg.enable {
    catppuccin.lazygit.enable = true;

    programs.lazygit = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
