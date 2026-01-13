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
      nameservers = [ "1.1.1.1" ];
    };
  };
}
