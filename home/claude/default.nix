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
  claude-nix-package = inputs.claude-code.packages.${system}.default;

  sensitivePaths = [
    # Environment files
    ".env"
    ".env.*"
    "**/.env"
    "**/.env.*"

    # Sensitive directories
    "~/.ssh/*"
    "~/.aws/*"
    "~/.config/sops/*"
    "**/secrets/**"

    # Credentials and keys
    "**/*credentials*"
    "**/*secret*"
    "**/*.pem"
    "**/*.key"

    # Token files
    "**/token*"

    # Local databases
    "**/*.sqlite"
    "**/*.db"

    # Git config (may contain tokens)
    "**/.git/config"
  ];

  denyPaths =
    paths:
    concatMap (path: [
      "Read(${path})"
      "Edit(${path})"
      "Write(${path})"
    ]) paths;

  bashCmds = cmds: map (cmd: "Bash(${cmd})") cmds;
  mcpTools = tools: map (tool: "mcp__${tool}") tools;
in
{
  options.modules.claude = {
    enable = mkEnableOption "Enable claude configuration";
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
      package = claude-nix-package;
      memory.source = ./memory.md;

      skillsDir = ./skills;

      settings = {
        outputStyle = "Explanatory";
        respectGitignore = true;
        showTurnDuration = true;
        cleanupPeriodDays = 30;

        permissions = {
          allow = [
            # Core built-in tools
            "Edit"
            "Glob"
            "Grep"
            "NotebookEdit"
            "Read"
            "Skill"
            "Task"
            "WebFetch"
            "WebSearch"
            "Write"
          ]
          # MCP Server Tools
          ++ mcpTools [
            # Full access (all tools)
            "context7__*"
            "memory__*"

            # MongoDB — READ ONLY
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
            "cp *"
            "ls *"
            "mkdir *"
            "mv *"
            "tree *"

            "diff *"
            "fd *"
            "jq *"
            "wc *"

            "chmod *"
            "which *"
            "env *"

            "git *"

            # Nix
            "nix search *"
            "nix fmt *"

            # Python
            "python *"
            "python3 *"
            "pytest *"
            "ruff *"
            "ty *"
            "uv *"
            "uvx *"
            "pre-commit *"

            # Node.js
            "npm *"
            "npx *"
            "node *"

            # Kotlin/JVM
            "gradle *"
            "./gradlew *"
            "java *"
            "kotlin *"

            # Infrastructure
            "docker *"
            "docker compose *"
            "make *"
            "curl *"
          ];

          deny = denyPaths sensitivePaths;
        };

        hooks = { };

        env = {
          CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR = 1;
          CLAUDE_CODE_SHELL = "zsh";
          DISABLE_TELEMETRY = 1;
          MCP_TIMEOUT = 30000;
        };
      };

      mcpServers = {
        context7 = {
          command = "npx";
          args = [
            "-y"
            "@upstash/context7-mcp@2.1.1"
          ];
        };

        memory = {
          command = "npx";
          args = [
            "-y"
            "@modelcontextprotocol/server-memory@2026.1.26"
          ];
        };

        mongodb = {
          command = "npx";
          args = [
            "-y"
            "@mongodb-js/mongodb-mcp-server@0.0.3"
          ];
        };
      };
    };
  };
}
