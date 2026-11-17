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

  statusline = import ./statusline.nix { inherit lib pkgs; };

  homeDirectory = config.home.homeDirectory;
  mcp = { inherit (config.programs.mcp) enable servers; };

  datadogWriteRules =
    concatMap
      (
        server:
        map (tool: "mcp__${server}__${tool}") [
          "add_*"
          "append_*"
          "batch_update_*"
          "create_*"
          "ddsql_upsert_saved_query"
          "delete_*"
          "edit_*"
          "execute_code_write"
          "execute_datadog_workflow"
          "manage_*"
          "move_*"
          "mute_*"
          "publish_*"
          "retry_datadog_ci_job"
          "run_*"
          "set_*"
          "trigger_*"
          "update-*"
          "update_*"
          "upsert_*"
        ]
      )
      [
        "claude_ai_Datadog"
        "claude_ai_Datadog_2"
      ];

  instance = {
    imports = [
      ./stubs.nix
      ./remote-control.nix
      "${inputs.home-manager}/modules/programs/claude-code"
    ];

    home = {
      inherit homeDirectory;
      inherit (config.home) stateVersion preferXdgDirectories;
    };
    xdg.configHome = config.xdg.configHome;
    programs.mcp = mcp;

    programs.claude-code = {
      enable = true;
      mutableSettings = true;
      package = llm-agents.claude-code;
      enableMcpIntegration = true;
      context = ../../common/llm-memory.md;
      commandsDir = ./commands;
      skills = ../../common/skills;

      settings = {
        alwaysThinkingEnabled = true;
        autoMemoryEnabled = true;
        cleanupPeriodDays = 30;
        editorMode = "vim";
        enableAllProjectMcpServers = true;
        outputStyle = "Default";
        respectGitignore = true;
        showTurnDuration = true;
        spinnerTipsEnabled = true;
        terminalProgressBarEnabled = true;

        permissions = {
          ask = [
            "Bash(git checkout -b *)"
            "Bash(git switch -c *)"
            "Bash(git -C * checkout -b *)"
            "Bash(git -C * switch -c *)"
            "Bash(git push *)"
            "Bash(git -C * push)"
            "Bash(git -C * push *)"
            "Bash(git -c * push)"
            "Bash(git -c * push *)"
            "Bash(git worktree add *)"
            "Bash(gh pr create *)"
          ]
          ++ datadogWriteRules;
          deny = [ "EnterWorktree" ];
        };

        statusLine = {
          type = "command";
          command = statusline.command;
        };

        env = {
          BASH_DEFAULT_TIMEOUT_MS = 300000; # Raised for long-running Nix builds and evaluations
          BASH_MAX_TIMEOUT_MS = 600000;
          CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR = 1;
          CLAUDE_CODE_EFFORT_LEVEL = "xhigh";
          CLAUDE_CODE_SHELL = "${pkgs.bash}/bin/bash";
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

  remoteControlServers = concatLists (
    mapAttrsToList (
      name: i:
      mapAttrsToList (server: directory: {
        session = "${name}-${server}";
        inherit directory;
        pane = "${pkgs.zsh}/bin/zsh -lc ${escapeShellArg "while true; do ${i.command} remote-control --permission-mode bypassPermissions --spawn same-dir --no-create-session-in-dir; sleep 10; done"}";
      }) i.remoteControl
    ) cfg.instances
  );

  remoteControlScript = pkgs.writeShellScript "claude-remote-control" ''
    ${optionalString (
      config.home.sessionVariables ? TMUX_TMPDIR
    ) "export TMUX_TMPDIR=${config.home.sessionVariables.TMUX_TMPDIR}"}
    tmux() { ${pkgs.tmux.override { withSystemd = false; }}/bin/tmux -L claude-rc -f /dev/null "$@"; }
    while true; do
    ${concatMapStrings (s: ''
      if test -d ${escapeShellArg s.directory} && ! tmux has-session -t ${escapeShellArg "=${s.session}"} 2>/dev/null; then
        tmux new-session -d -s ${escapeShellArg s.session} -c ${escapeShellArg s.directory} ${escapeShellArg s.pane}
      fi
    '') remoteControlServers}
      sleep 60
    done
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
        (with llm-agents; [
          ccstatusline
          ccusage
        ])
        ++ map wrapper instances;

      file = mkMerge (map (i: i.home.file) instances);
      activation = mkMerge (
        mapAttrsToList (
          name: i: mapAttrs' (n: nameValuePair "${n}-${name}") i.home.activation
        ) cfg.instances
      );
      sessionVariables.CLAUDE_CONFIG_DIR = "${homeDirectory}/.claude";
    };

    warnings = concatMap (i: i.warnings) instances;
    assertions = concatMap (i: i.assertions) instances;

    xdg.configFile = statusline.configFile;

    systemd.user.services.claude-remote-control =
      mkIf (pkgs.stdenv.hostPlatform.isLinux && remoteControlServers != [ ])
        {
          Unit.Description = "Claude Code Remote Control servers in tmux";
          Service = {
            ExecStart = "${remoteControlScript}";
            KillMode = "process";
            Restart = "always";
            RestartSec = 10;
          };
          Install.WantedBy = [ "default.target" ];
        };

    launchd.agents.claude-remote-control =
      mkIf (pkgs.stdenv.hostPlatform.isDarwin && remoteControlServers != [ ])
        {
          enable = true;
          config = {
            ProgramArguments = [ "${remoteControlScript}" ];
            KeepAlive = true;
            RunAtLoad = true;
            ProcessType = "Background";
            StandardOutPath = "${homeDirectory}/Library/Logs/claude-remote-control.log";
            StandardErrorPath = "${homeDirectory}/Library/Logs/claude-remote-control.log";
          };
        };
  };
}
