{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.packages.development;
in
{
  options.modules.packages.development = {
    enable = mkEnableOption "Enable development packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      ripgrep
      fd
      tree-sitter
      vi-mongo
    ];
  };
}
