{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.mcp.servers.anki;
  addon = inputs.anki-mcp.packages.${pkgs.stdenv.hostPlatform.system}.addon;
in
{
  config = mkMerge [
    {
      modules.mcp.servers.anki.server.url = "http://127.0.0.1:3141/";
    }

    (mkIf cfg.enable {
      home.packages = [ (pkgs.anki.withAddons [ addon ]) ];
    })
  ];
}
