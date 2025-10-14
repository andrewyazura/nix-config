{ lib, config, ... }:
with lib;
let cfg = config.modules.git;
in {
  options.modules.git = { enable = mkEnableOption "Enable git configuration"; };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;

      includes = [{
        condition = "gitdir:~/Documents/";
        contents = {
          user = {
            name = "Andrew Yatsura";
            email = "andrewyazura203@proton.me";
          };
        };
      }];
    };
  };
}
