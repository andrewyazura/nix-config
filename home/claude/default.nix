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
  llm-agents = inputs.llm-agents.packages.${system};

  hooks = import ./hooks.nix { inherit lib pkgs; };
  statusline = import ./statusline.nix { inherit lib pkgs; };

  homeDirectory = config.home.homeDirectory;
  mcp = { inherit (config.programs.mcp) enable servers; };

  instance = {
    imports = [
      ./stubs.nix
      "${inputs.home-manager}/modules/programs/claude-code"
    ];

    home.homeDirectory = homeDirectory;
    programs.mcp = mcp;

    programs.claude-code = {
      enable = true;
      package = llm-agents.claude-code;
      enableMcpIntegration = true;
      context = ../../common/llm-memory.md;
      skills = ./skills;
      commandsDir = ./commands;

      settings = {
        # Response formatting style
        # https://code.claude.com/docs/en/output-styles
        outputStyle = "Concise";

        # Vim keybindings in the prompt input
        # https://code.claude.com/docs/en/interactive-mode
        editorMode = "vim";

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

        # Agent team display mode: split panes in tmux, fallback to in-process
        # https://code.claude.com/docs/en/agent-teams
        teammateMode = "tmux";
        alwaysThinkingEnabled = true;
        modelSettings =
          genAttrs
            [
              "claude-opus-5-5"
              "claude-fable-5-1"
              "claude-sonnet-5"
              "claude-haiku-4-5"
            ]
            (_: {
              effortLevel = "xhigh";
            });

        # Deliver messages from other sessions without a review prompt
        crossSessionInbound = "accept";

        # Bottom status bar showing model and context usage
        # https://code.claude.com/docs/en/statusline
        statusLine = {
          type = "command";
          command = statusline.command;
        };

        inherit hooks;

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

          # Disable built-in auto-updater — Claude is managed via Nix flake input
          DISABLE_AUTOUPDATER = 1;

          # Token budget for extended thinking (default: varies by model)
          MAX_THINKING_TOKENS = 32000;

          # MCP server startup timeout in ms (default: 10000)
          # https://code.claude.com/docs/en/mcp
          MCP_TIMEOUT = 30000;
        };
      };
    };
  };

  instances = attrValues cfg.instances;

  wrapper =
    i:
    pkgs.writeShellScriptBin i.command ''
      export CLAUDE_CONFIG_DIR=${i.programs.claude-code.configDir}
      exec ${i.programs.claude-code.finalPackage}/bin/claude "$@"
    '';
in
{
  options.modules.claude = {
    enable = mkEnableOption "Enable claude configuration";

    instances = mkOption {
      type = types.attrsOf (
        types.submoduleWith {
          specialArgs = { inherit lib pkgs; };
          modules = [ instance ];
        }
      );
      default = { };
    };
  };

  config = mkIf cfg.enable {
    modules.claude.instances.personal = {
      command = "claude";

      # Disable crash/error reporting (pairs with DISABLE_TELEMETRY)
      programs.claude-code.settings.env.DISABLE_ERROR_REPORTING = 1;
    };

    home.packages =
      (with llm-agents; [
        ccstatusline
        ccusage
      ])
      ++ map wrapper instances;

    home.file = mkMerge (map (i: i.home.file) instances);

    home.sessionVariables.CLAUDE_CONFIG_DIR = "${homeDirectory}/.claude";

    warnings = concatMap (i: i.warnings) instances;
    assertions = concatMap (i: i.assertions) instances;

    xdg.configFile = statusline.configFile;
  };
}
