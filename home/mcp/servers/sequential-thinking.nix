{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.mcp.servers.sequential-thinking;
in
{
  config = mkMerge [
    {
      modules.mcp.servers.sequential-thinking.server = {
        command = "npx";
        args = [
          "-y"
          "@modelcontextprotocol/server-sequential-thinking@2025.12.18"
        ];
      };
    }

    (mkIf cfg.enable {
      home.packages = [ pkgs.nodejs_24 ];
    })
  ];
}
