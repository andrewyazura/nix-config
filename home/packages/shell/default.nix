{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.packages.shell;
in
{
  options.modules.packages.shell = {
    enable = mkEnableOption "Enable shell enhancement packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fastfetch
    ];
  };
}
