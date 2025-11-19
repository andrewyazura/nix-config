{ lib, config, ... }:
with lib;
let cfg = config.modules.nix;
in {
  imports = [ ../../common/nix ];

  options.modules.nix = { enable = mkEnableOption "Enable nix configuration"; };

  config = mkIf cfg.enable {
    programs = {
      gnupg.agent.enable = true;
      zsh.enable = true;
    };
  };
}
