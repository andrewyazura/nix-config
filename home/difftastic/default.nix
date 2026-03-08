{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.difftastic;
in
{
  options.modules.difftastic = {
    enable = mkEnableOption "Enable difftastic configuration";
  };

  config = mkIf cfg.enable {
    programs.difftastic = {
      enable = true;
      git = {
        enable = true;
        diffToolMode = true;
      };
    };
  };
}
