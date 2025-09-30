{ lib, config, ... }:
with lib;
let cfg = config.modules.git;
in {
  options.modules.git = { enable = mkEnableOption "Enable git configuration"; };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      lfs.enable = true;
      extraConfig = {
        "includeIf \"gitdir:~/Documents/\"" = {
          path = "~/.personal.gitconfig";
        };
      };
    };

    home.file.".personal.gitconfig".source = ./.personal.gitconfig;
  };
}
