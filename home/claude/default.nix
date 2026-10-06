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
      commandsDir = ./commands;

      settings = {
        alwaysThinkingEnabled = true;
        autoMemoryEnabled = true;
        cleanupPeriodDays = 30;
        crossSessionInbound = "accept";
        editorMode = "vim";
        enableAllProjectMcpServers = true;
        model = "opus";
        outputStyle = "Default";
        respectGitignore = true;
        showTurnDuration = true;
        spinnerTipsEnabled = true;
        terminalProgressBarEnabled = true;

        inherit hooks;

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

        statusLine = {
          type = "command";
          command = statusline.command;
        };

        env = {
          BASH_DEFAULT_TIMEOUT_MS = 300000; # Raised for long-running Nix builds and evaluations
          BASH_MAX_TIMEOUT_MS = 600000;
          CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR = 1;
          CLAUDE_CODE_SHELL = "zsh";
          DISABLE_AUTOUPDATER = 1;
          DISABLE_ERROR_REPORTING = 1;
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
    modules.claude.instances.personal.command = "claude";

    home = {
      packages =
        (with pkgs; [ sox ])
        ++ (with llm-agents; [
          ccstatusline
          ccusage
        ])
        ++ map wrapper instances;

      file = mkMerge (map (i: i.home.file) instances);
      sessionVariables.CLAUDE_CONFIG_DIR = "${homeDirectory}/.claude";
    };

    warnings = concatMap (i: i.warnings) instances;
    assertions = concatMap (i: i.assertions) instances;

    xdg.configFile = statusline.configFile;
  };
}
