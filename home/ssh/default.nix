{ lib, config, ... }:
with lib;
let cfg = config.modules.ssh;
in {
  options.modules.ssh = { enable = mkEnableOption "Enable SSH configuration"; };

  config = mkIf cfg.enable { home.file.".ssh/config".source = ./config; };
}
