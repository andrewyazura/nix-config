{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.wooting;
in {
  options.modules.wooting = {
    enable = mkEnableOption "Enable wooting configuration";
  };

  config =
    mkIf cfg.enable { services.udev.packages = [ pkgs.wooting-udev-rules ]; };
}
