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
  statusline = import ./statusline.nix { inherit pkgs; };

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
        # Response formatting style
        # https://code.claude.com/docs/en/output-styles
        outputStyle = "Explanatory";

        # Honor .gitignore patterns in file picker and search
        # https://code.claude.com/docs/en/settings
        respectGitignore = true;

        # Show duration of each turn in the UI
        showTurnDuration = true;

        # Days before inactive session transcripts are auto-deleted
        cleanupPeriodDays = 30;

        # Auto-save learnings per-project to ~/.claude/projects/<project>/memory/
        # https://code.claude.com/docs/en/memory
        autoMemoryEnabled = true;

        # Auto-approve project-level .mcp.json servers without prompting
        # https://code.claude.com/docs/en/mcp
        enableAllProjectMcpServers = true;

        # Show progress bar in terminal during operations
        terminalProgressBarEnabled = true;

        # Show usage tips in the spinner while Claude works
        spinnerTipsEnabled = true;

        # Bottom status bar showing model and context usage
        # https://code.claude.com/docs/en/statusline
        statusLine = {
          type = "command";
          command = "${statusline}";
        };

        inherit hooks;
        inherit permissions;

        env = {
          # Default timeout for Bash tool commands in ms (default: 120000)
          # Raised for long-running Nix builds and evaluations
          BASH_DEFAULT_TIMEOUT_MS = 300000;

          # Hard ceiling for Bash tool command timeouts in ms (default: 600000)
          BASH_MAX_TIMEOUT_MS = 600000;

          # Subagent Bash commands stay in project dir instead of resetting cwd
          CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR = 1;

          # Shell used for Bash tool execution
          CLAUDE_CODE_SHELL = "zsh";

          # Disable all telemetry/analytics
          # https://code.claude.com/docs/en/settings
          DISABLE_TELEMETRY = 1;

          # Disable crash/error reporting (pairs with DISABLE_TELEMETRY)
          DISABLE_ERROR_REPORTING = 1;

          # Disable built-in auto-updater — Claude is managed via Nix flake input
          DISABLE_AUTOUPDATER = 1;

          # Token budget for extended thinking (default: varies by model)
          MAX_THINKING_TOKENS = 32000;

          # MCP server startup timeout in ms (default: 10000)
          # https://code.claude.com/docs/en/mcp
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
