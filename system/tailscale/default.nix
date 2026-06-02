{ config, lib, ... }:

let
  cfg = config.modules.tailscale;
in
{
  options.modules.tailscale = {
    enable = lib.mkEnableOption "tailscale";
  };

  config = lib.mkIf cfg.enable {
    services = {
      tailscale.enable = true;
      openssh.enable = true;
    };

    programs.mosh.enable = true;
  };
}
