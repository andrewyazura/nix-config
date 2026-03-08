{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.git;
in
{
  options.modules.git = {
    enable = mkEnableOption "Enable git configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.difftastic ];

    programs.git = {
      enable = true;
      lfs.enable = true;

      signing = {
        key = "970E41F6C58CCA2A";
        signByDefault = true;
      };

      includes = [
        {
          contents = {
            user = {
              name = "Andrew Yatsura";
              email = "andrewyazura203@gmail.com";
            };
          };
        }
      ];
    };
  };
}
