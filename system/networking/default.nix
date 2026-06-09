{
  lib,
  config,
  hostname,
  ...
}:
with lib;
let
  cfg = config.modules.networking;
in
{
  options.modules.networking = {
    enable = mkEnableOption "Enable networking configuration";
  };

  config = mkIf cfg.enable {
    networking = {
      hostName = hostname;
      networkmanager.enable = true;
      networkmanager.wifi.powersave = false;
      nameservers = [ "1.1.1.1" ];
    };
  };
}
