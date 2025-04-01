{ lib, config, ... }:
with lib;
let cfg = config.modules.csgo-server;
in {
  options.modules.csgo-server = {
    enable = mkEnableOption "Enable CS:GO server configuration";
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedUDPPorts = [
      27015 # game transmission
      27020 # sourcetv
      27005 # client port
      26900 # steam port
    ];
  };
}
