{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.mcp;
in
{
  options.modules.mcp = {
    enable = mkEnableOption "Enable MCP configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_24 # provides npx for MCP servers
    ];

    programs.mcp = {
      enable = true;
      servers = {
        context7 = {
          command = "npx";
          args = [
            "-y"
            "@upstash/context7-mcp@2.1.1"
          ];
        };

        mongodb = {
          command = "npx";
          args = [
            "-y"
            "@mongodb-js/mongodb-mcp-server@0.0.3"
          ];
        };

        sequential-thinking = {
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-sequential-thinking@2025.12.18"
          ];
        };
      };
    };
  };
}
