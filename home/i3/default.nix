{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.i3;
in {
  options.modules.i3 = { enable = mkEnableOption "Enable i3 configuration"; };

  config = mkIf cfg.enable {
    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = { modifier = "Mod4"; };
    };
  };
}
