{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.anki;
  addon = inputs.anki-mcp.packages.${pkgs.stdenv.hostPlatform.system}.addon;
in
{
  options.modules.anki = {
    enable = mkEnableOption "Enable Anki with the MCP server add-on";
  };

  config = mkIf cfg.enable {
    home.packages = [ (pkgs.anki.withAddons [ addon ]) ];
  };
}
