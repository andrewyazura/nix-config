{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.mcp.servers.mongodb;
in
{
  config = mkMerge [
    {
      modules.mcp.servers.mongodb.server = {
        command = "npx";
        args = [
          "-y"
          "@mongodb-js/mongodb-mcp-server@0.0.3"
        ];
      };
    }

    (mkIf cfg.enable {
      home.packages = [ pkgs.nodejs_24 ];
    })
  ];
}
