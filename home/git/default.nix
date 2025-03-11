{ lib, config, ... }:
with lib;
let cfg = config.modules.git;
in {
  options.modules.git = { enable = mkEnableOption "Enable git configuration"; };

  config = mkIf cfg.enable {
    programs.git.enable = true;
    home.file.".gitconfig".source = ./.gitconfig;
    home.file.".personal.gitconfig".source = ./.personal.gitconfig;
    home.file.".spacedevlab.gitconfig".source = ./.spacedevlab.gitconfig;
  };
}
