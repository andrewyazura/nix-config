{ config, lib, ... }:

let
  cfg = config.modules.oo7;
in
{
  options.modules.oo7 = {
    enable = lib.mkEnableOption "oo7";
  };

  config = lib.mkIf cfg.enable {
    services.oo7.enable = true;

    xdg.portal.config.common."org.freedesktop.impl.portal.Secret" = [ "none" ];

    systemd.user.services.oo7-daemon = {
      restartIfChanged = false;
      serviceConfig.MemorySwapMax = 0;
    };
  };
}
