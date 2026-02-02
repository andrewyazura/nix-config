{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.claude;
in
{
  options.modules.claude = {
    enable = mkEnableOption "Enable claude configuration";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_24 # provides npx for mcp
    ];

    programs.claude-code = {
      enable = true;
      memory.source = ./memory.md;

      commandsDir = ./commands;
      skillsDir = ./skills;

      settings = {
        alwaysThinkingEnabled = true;
        cleanupPeriodDays = 30;
        model = "opusplan";
        outputStyle = "Explanatory";
        planningMode = "auto";
        respectGitignore = true;

        permissions =
          let
            bashCmds = cmds: map (cmd: "Bash(${cmd})") cmds;
            mcpTools = tools: map (tool: "mcp__${tool}") tools;
          in
          {
            allow = [
              "Edit"
              "Explore"
              "Read"
              "Search"
              "Skill"
              "WebFetch"
              "WebSearch"
              "Write"
            ]
            # MCP Server Tools
            ++ mcpTools [
              # Full access (all tools)
              "context7__*"
              "memory__*"

              # MongoDB - READ ONLY
              "mongodb__connect"
              "mongodb__list-databases"
              "mongodb__list-collections"
              "mongodb__find"
              "mongodb__count"
              "mongodb__aggregate"
              "mongodb__collection-schema"
              "mongodb__collection-indexes"
              "mongodb__collection-storage-size"
              "mongodb__db-stats"
              "mongodb__explain"
              "mongodb__atlas-list-projects"
              "mongodb__atlas-list-clusters"
              "mongodb__atlas-inspect-cluster"
              "mongodb__atlas-inspect-access-list"
              "mongodb__atlas-list-db-users"
            ]
            # Shell utilities
            ++ bashCmds [
              "cat *"
              "cp *"
              "ls *"
              "mkdir *"
              "mv *"
              "tree *"

              "head *"
              "tail *"

              "diff *"
              "fd *"
              "find *"
              "grep *"
              "jq *"
              "rg *"
              "wc *"

              "git *"

              # Nix
              "nix search *"
              "nix fmt *"

              # Python
              "python *"
              "python3 *"
              "pytest *"
              "mypy *"
              "uv *"
              "uvx *"
              "pre-commit run *"
              "pip *"

              # Node.js
              "npm *"
              "npx *"
              "node *"
              "nvm *"
            ];

            deny = [
              # Environment files
              "Read(.env)"
              "Read(.env.*)"
              "Read(**/.env)"
              "Read(**/.env.*)"

              # Sensitive directories
              "Read(~/.ssh/*)"
              "Read(~/.aws/*)"
              "Read(~/.config/sops/*)"
              "Read(**/secrets/**)"

              # Credentials and keys
              "Read(**/*credentials*)"
              "Read(**/*secret*)"
              "Read(**/*.pem)"
              "Read(**/*.key)"

              # Token files
              "Read(**/token*)"

              # Local databases
              "Read(**/*.sqlite)"
              "Read(**/*.db)"

              # Git config (may contain tokens)
              "Read(**/.git/config)"
            ];
          };

        hooks = { };

        env = {
          CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR = 1;
          CLAUDE_CODE_DISABLE_TERMINAL_TITLE = 0;
          CLAUDE_CODE_SHELL = "zsh";
          DISABLE_NON_ESSENTIAL_MODEL_CALLS = 1;
          DISABLE_TELEMETRY = 1;
        };
      };

      mcpServers = {
        context7 = {
          command = "npx";
          args = [
            "-y"
            "@upstash/context7-mcp"
          ];
        };

        memory = {
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-memory"
          ];
        };

        mongodb = {
          command = "npx";
          args = [
            "-y"
            "@mongodb-js/mongodb-mcp-server"
          ];
        };
      };
    };
  };
}
