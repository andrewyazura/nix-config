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

  soundsDir = ./sounds;
  mpvBin = lib.getExe pkgs.mpv;

  soundHook = command: {
    type = "command";
    inherit command;
    timeout = 10;
    async = true;
  };

  playSound = file: soundHook "${mpvBin} --no-video --really-quiet ${soundsDir}/${file}";

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
            "sequential-thinking__*"

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

            # IDE integration
            "ide__getDiagnostics"

            # Datadog — full access
            "datadog-mcp__*"
          ]
          # Shell utilities
          ++ bashCmds [
            "basename *"
            "cat *"
            "chmod *"
            "cp *"
            "cut *"
            "date *"
            "diff *"
            "dirname *"
            "du *"
            "echo *"
            "env *"
            "fd *"
            "file *"
            "find *"
            "head *"
            "jq *"
            "ln *"
            "ls *"
            "mkdir *"
            "mv *"
            "pwd *"
            "readlink *"
            "realpath *"
            "sort *"
            "stat *"
            "tail *"
            "tar *"
            "touch *"
            "tr *"
            "tree *"
            "uniq *"
            "wc *"
            "which *"
            "xargs *"
            "curl *"
            "grep *"
            "rg *"
            "rm *"
            "ssh *"
            "tee *"
            "test *"
            "timeout *"
            "zip *"
            "unzip *"
            "wait"
            "export *"
            "source *"
            "tree-sitter *"

            # Version control
            "git *"
            "gh *"

            # Nix ecosystem
            "nix*"

            # Python
            "python *"
            "python3 *"
            "pytest *"
            "ruff *"
            "ty *"
            "pre-commit *"
            "poetry *"
            "mypy *"
            "uv *"
            "uvx *"
            ".venv/bin/python *"
            ".venv/bin/ruff *"

            # Environment-prefixed commands
            "PYTHONPATH=* *"
            "DD_TRACE_ENABLED=* *"
            "SKIP_INTEGRATION_TESTS=* *"
            "CI=* *"

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
            "make *"
          ];

          ask = bashCmds [
            "npm i *"
            "npm install *"
          ];

          deny =
            (denyPaths sensitivePaths)
            ++ bashCmds [
              # Git — destructive operations
              "git push *"
              "git push --force *"
              "git push -f *"
              "git reset --hard *"
              "git checkout -- *"
              "git restore . *"
              "git clean -f *"
              "git clean -fd *"
              "git branch -D *"

              # Nix — garbage collection and removal (legacy + new CLI)
              "nix-env -e *"
              "nix-env --uninstall *"
              "nix-store --delete *"
              "nix-store --gc *"
              "nix-collect-garbage *"
              "nix store gc *"
              "nix store delete *"
              "nix profile remove *"

              # Docker — destructive operations
              "docker system *"
              "docker volume rm *"

              # Filesystem — destructive
              "rm -r *"
              "rm -rf *"
              "chmod 777 *"
            ];
        };

        hooks = {
          UserPromptSubmit = [
            {
              hooks = [
                (soundHook "bash -c '${mpvBin} --no-video --really-quiet ${soundsDir}/officer$((RANDOM % 2 + 1)).ogg'")
              ];
            }
          ];
          PostToolUseFailure = [
            {
              matcher = "Bash";
              hooks = [ (playSound "alarm.ogg") ];
            }
          ];
          PermissionRequest = [
            {
              hooks = [ (playSound "alarm.ogg") ];
            }
          ];
          Stop = [
            {
              hooks = [ (playSound "upgbar.ogg") ];
            }
          ];
          Notification = [
            {
              matcher = "^(?!permission_prompt|idle_prompt)";
              hooks = [ (playSound "bldaca.ogg") ];
            }
          ];
        };

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
