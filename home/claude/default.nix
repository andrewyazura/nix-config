{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.claude;

  bashCmds = cmds: map (cmd: "Bash(${cmd})") cmds;
  webDomains = domains: map (domain: "WebFetch(domain:${domain})") domains;
in
{
  options.modules.claude = {
    enable = mkEnableOption "Enable claude configuration";
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;

      memory.text = ''
        # Global Preferences

        ## Communication
        - When coding: be concise and informative
        - When planning/brainstorming: ultrathink deeply, present ALL viable options with trade-offs so I can make informed decisions

        ## Workflow
        Follow this sequence for implementation tasks:

        1. **Explore & Plan**: Research the codebase thoroughly. Present options. Do NOT write code yet.
        2. **Design**: Write function signatures, type definitions, data structures. Validate they compose correctly.
        3. **Test**: Write tests that verify the signatures/types work as intended.
        4. **Implement**: Write the implementation. Run tests. Iterate until green.

        If signatures don't compose well → return to planning.
        If tests reveal design flaws → return to signatures.

        ## Code Philosophy
        - Functional programming: pure functions, composition, declarative style
        - Immutability by default
        - Error handling via Result/Either monads - no exceptions for control flow
        - Make illegal states unrepresentable through types
        - Explicit over implicit
        - Delete dead code, don't comment it out

        ## Safety
        - Never skip tests or verification steps
        - Never commit secrets, credentials, or API keys
        - Warn before destructive operations
        - Check for existing patterns before introducing new ones

        ## Environment
        - Shell: zsh
        - Editor: neovim
        - Search: fd, rg (ripgrep)
        - JSON: jq
      '';

      settings = {
        alwaysThinkingEnabled = true;
        cleanupPeriodDays = 30;
        model = "opusplan";
        outputStyle = "Explanatory";
        respectGitignore = true;

        permissions = {
          allow = [
            "Edit"
            "Skill"
            "WebSearch"
            "Write"
          ]
          ++ bashCmds [
            "tree *"
            "wc *"
            "diff *"
            "jq *"
          ]
          ++ webDomains [
            "*.github.com"
            "*.githubusercontent.com"
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
          CLAUDE_CODE_SHELL = "zsh";
          CLAUDE_CODE_DISABLE_TERMINAL_TITLE = 0;
          DISABLE_TELEMETRY = 1;
          DISABLE_NON_ESSENTIAL_MODEL_CALLS = 1;
        };
      };
    };
  };
}
