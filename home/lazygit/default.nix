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
    programs.lazygit = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
