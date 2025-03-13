{ lib, config, ... }:
with lib;
let cfg = config.modules.i3;
in {
  options.modules.i3 = { enable = mkEnableOption "Enable i3 configuration"; };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        windowManager.i3.enable = true;
      };
      services.displayManager = { defaultSession = "none+i3"; };
    };
  };
}
