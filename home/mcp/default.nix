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

  toAntigravity =
    server: removeAttrs server [ "url" ] // optionalAttrs (server ? url) { serverUrl = server.url; };
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

    claudeConfigs = mkOption {
      type = types.attrsOf types.path;
      internal = true;
      readOnly = true;
      description = "MCP config file for each scoped directory, keyed by absolute path.";
    };
  };

  config = {
    modules.mcp.claudeConfigs = listToAttrs (
      map (
        dir:
        nameValuePair "${config.home.homeDirectory}/${dir}" (
          jsonFormat.generate "claude-mcp.json" {
            mcpServers = mapAttrs (_: hm.mcp.addType) (serversIn dir);
          }
        )
      ) directories
    );

    programs.mcp = mkIf (global != { }) {
      enable = true;
      servers = mapAttrs (_: s: s.server) global;
    };

    programs.antigravity-cli.settings.trustedWorkspaces = mkIf (directories != [ ]) (
      map (dir: "${config.home.homeDirectory}/${dir}") directories
    );

    home.file = mkMerge (
      map (dir: {
        "${dir}/.agents/plugins/nix-mcp/plugin.json".source = jsonFormat.generate "plugin.json" {
          name = "nix-mcp";
        };
        "${dir}/.agents/plugins/nix-mcp/mcp_config.json".source = jsonFormat.generate "mcp_config.json" {
          mcpServers = mapAttrs (_: toAntigravity) (serversIn dir);
        };
      }) directories
    );
  };
}
