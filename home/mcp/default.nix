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
  global = filterAttrs (_: s: s.directories == [ ]) enabled;
  scoped = filterAttrs (_: s: s.directories != [ ]) enabled;
  directories = unique (concatMap (s: s.directories) (attrValues scoped));

  serversIn = dir: mapAttrs (_: s: s.server) (filterAttrs (_: s: elem dir s.directories) scoped);
in
{
  imports = [
    ./servers/anki.nix
    ./servers/context7.nix
    ./servers/mongodb.nix
    ./servers/sequential-thinking.nix
  ];

  options.modules.mcp = {
    servers = mkOption {
      type = types.attrsOf (
        types.submodule {
          options = {
            enable = mkEnableOption "this MCP server";

            directories = mkOption {
              type = types.listOf types.str;
              default = [ ];
              description = "Directories relative to home where the server is active. Empty means everywhere.";
            };

            server = mkOption {
              inherit (jsonFormat) type;
            };
          };
        }
      );
      default = { };
    };

    scoped = mkOption {
      type = types.attrsOf (types.attrsOf jsonFormat.type);
      internal = true;
      readOnly = true;
      description = "Enabled servers for each scoped directory, keyed by absolute path.";
    };
  };

  config = {
    assertions = mapAttrsToList (name: s: {
      assertion = (s.server ? command) != (s.server ? url);
      message = "modules.mcp.servers.${name}: exactly one of `command` or `url` must be set.";
    }) enabled;

    modules.mcp.scoped = listToAttrs (
      map (dir: nameValuePair "${config.home.homeDirectory}/${dir}" (serversIn dir)) directories
    );

    programs.mcp = mkIf (global != { }) {
      enable = true;
      servers = mapAttrs (_: s: s.server) global;
    };
  };
}
