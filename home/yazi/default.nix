{ lib, config, ... }:
with lib;
let cfg = config.modules.yazi;
in {
  options.modules.yazi = {
    enable = mkEnableOption "Enable yazi configuration";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = { mgr = { show_hidden = true; }; };
    };
  };
}
