{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.gemini;
  system = pkgs.stdenv.hostPlatform.system;
  gemini-package = inputs.llm-agents.packages.${system}.gemini-cli;

  mcpCfg = config.programs.mcp;
in
{
  options.modules.gemini = {
    enable = mkEnableOption "Enable gemini configuration";
  };

  config = mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;
      package = gemini-package;

      settings = {
        # Vim keybindings in the input field
        vimMode = false;

        # How to handle tool execution approvals (default, always, never)
        defaultApprovalMode = "default";

        # Automatically check for updates on startup
        enableAutoUpdate = true;

        # Max context turns to retain in the session
        maxSessionTurns = -1;

        # Threshold to trigger context compression (0.0 - 1.0)
        compressionThreshold = 0.5;

        # Output format (text, json)
        outputFormat = "text";

        # Show line numbers in code blocks
        showLineNumbers = true;

        # Honor .gitignore patterns in file picker and search
        respectGitignore = true;

        # Use ripgrep for searching if available
        useRipgrep = true;

        # Enable agent skills
        enableSkills = true;

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
  };
}
