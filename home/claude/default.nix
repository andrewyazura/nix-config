{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.claude;
  system = pkgs.stdenv.hostPlatform.system;
  claude-package = inputs.claude-code.packages.${system}.default;

  hooks = import ./hooks.nix { inherit lib pkgs; };
  permissions = import ./permissions.nix { inherit lib; };

  mcpCfg = config.programs.mcp;
in
{
  options.modules.claude = {
    enable = mkEnableOption "Enable claude configuration";
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      package = claude-package;
      memory.source = ./memory.md;
      skillsDir = ./skills;

      settings = {
        outputStyle = "Explanatory";
        respectGitignore = true;
        showTurnDuration = true;
        cleanupPeriodDays = 30;

        inherit hooks;
        inherit permissions;

        env = {
          CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR = 1;
          CLAUDE_CODE_SHELL = "zsh";
          DISABLE_TELEMETRY = 1;
          MCP_TIMEOUT = 30000;
        };
      };

      mcpServers = mkIf mcpCfg.enable (
        mapAttrs (
          name: server:
          {
            command = server.command;
            args = server.args or [ ];
          }
          // optionalAttrs (server ? env) { env = server.env; }
        ) mcpCfg.servers
      );
    };
  };
}
