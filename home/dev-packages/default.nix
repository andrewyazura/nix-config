{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.dev-packages;
in
{
  options.modules.dev-packages = {
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
