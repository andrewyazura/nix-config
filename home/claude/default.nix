{
  lib,
  config,
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
          in
          {
            allow = [
              "Edit"
              "Skill"
              "WebFetch"
              "WebSearch"
              "Write"
            ]
            ++ bashCmds [
              "ls *"
              "tree *"

              "head *"
              "tail *"

              "wc *"
              "diff *"
              "jq *"
              "rg *"
              "fd *"

              "git log *"
              "git diff *"
              "git show *"
              "git blame *"
            ];

            deny = [
              "Read(.env)"
              "Read(.env.*)"
              "Read(**/.env)"
              "Read(**/.env.*)"

              "Read(~/.ssh/*)"
              "Read(~/.aws/*)"
              "Read(~/.config/sops/*)"
              "Read(**/secrets/**)"
              "Read(**/*credentials*)"
              "Read(**/*.pem)"
              "Read(**/*.key)"
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
    };
  };
}
