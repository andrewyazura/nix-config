{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.antigravity;
  system = pkgs.stdenv.hostPlatform.system;
  llm-agents = inputs.llm-agents.packages.${system};

  hooks = import ./hooks.nix { inherit lib pkgs; };
  jsonFormat = pkgs.formats.json { };

  scoped = config.modules.mcp.scoped;

  toAntigravity =
    name: server:
    let
      s = hm.mcp.transformMcpServer {
        inherit server;
        extraTransforms = [ (hm.mcp.wrapEnvFilesCommand { inherit pkgs name; }) ];
      };
    in
    removeAttrs s [ "url" ] // optionalAttrs (s ? url) { serverUrl = s.url; };
in
{
  options.modules.antigravity = {
    enable = mkEnableOption "Enable antigravity configuration";
  };

  config = mkIf cfg.enable {
    programs.antigravity-cli = {
      enable = true;
      package = llm-agents.antigravity-cli;
      defaultModel = "gemini-3.8-flash-high";
      enableMcpIntegration = true;

      context = {
        GEMINI = ../../common/llm-memory.md;
      };

      skills = ../claude/skills;

      settings = {
        model = "Gemini 3.8 Flash (High)";
        notifications = true;
        runningLightSpeed = "fast";
        toolPermission = "always-proceed";
        trustedWorkspaces = mkIf (scoped != { }) (attrNames scoped);
      };
    };

    home.file = {
      ".gemini/config/hooks.json" = {
        source = jsonFormat.generate "antigravity-hooks.json" hooks;
        force = true;
      };
      ".gemini/antigravity-cli/settings.json".force = true;
      ".gemini/config/mcp_config.json" = mkIf (config.programs.antigravity-cli.mcpServers != { }) {
        force = true;
      };
    }
    // concatMapAttrs (dir: servers: {
      "${dir}/.agents/plugins/nix-mcp/plugin.json".source = jsonFormat.generate "plugin.json" {
        name = "nix-mcp";
      };
      "${dir}/.agents/plugins/nix-mcp/mcp_config.json".source = jsonFormat.generate "mcp_config.json" {
        mcpServers = mapAttrs toAntigravity servers;
      };
    }) scoped;
  };
}
