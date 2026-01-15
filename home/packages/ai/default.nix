{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.packages.ai;
in
{
  options.modules.packages.ai = {
    enable = mkEnableOption "Enable AI CLI packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gemini-cli
    ];
  };
}
