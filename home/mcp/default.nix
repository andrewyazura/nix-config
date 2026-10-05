{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.mcp;
  jsonFormat = pkgs.formats.json { };

  enabled = filterAttrs (_: s: s.enable) cfg.servers;
in
{
  options.modules.mcp = {
    servers = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkEnableOption "this MCP server";

            server = mkOption {
              inherit (jsonFormat) type;
            };
          };
        }
      );
      default = { };
    };
  };

  config.programs.mcp = mkIf (enabled != { }) {
    enable = true;
    servers = mapAttrs (_: s: s.server) enabled;
  };
}
