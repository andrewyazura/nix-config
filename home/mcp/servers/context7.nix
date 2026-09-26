{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.mcp.servers.context7;
in
{
  config = mkMerge [
    {
      modules.mcp.servers.context7.server = {
        command = "npx";
        args = [
          "-y"
          "@upstash/context7-mcp@2.1.1"
        ];
      };
    }

    (mkIf cfg.enable {
      home.packages = [ pkgs.nodejs_24 ];
    })
  ];
}
