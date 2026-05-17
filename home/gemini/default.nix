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
  llm-agents = inputs.llm-agents.packages.${system};

  startSessionHook = pkgs.writeShellScript "start-session-hook" ''
    cat > ~/gemini.log
  '';
in
{
  options.modules.gemini = {
    enable = mkEnableOption "Enable gemini configuration";
  };

  config = mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;
      package = llm-agents.gemini-cli;

      context.GEMINI = ../../common/llm-memory.md;

      settings = {
        general = {
          vimMode = true;
          checkpointing.enabled = false;

          defaultApprovalMode = "auto_edit";

          sessionRetention = {
            enabled = true;
            maxAge = "120d";
          };

          # Notifications (macOS only)
          enableNotifications = true;
          enableAutoUpdate = false;
        };

        context = {
          fileFiltering = {
            respectGitIgnore = true;
          };
        };

        ui = {
          inlineThinkingMode = "full";
          dynamicWindowTitle = true;
          showMemoryUsage = true;
          showCitations = true;
          showModelInfoInChat = true;
          showUserIdentity = true;
          loadingPhrases = "all";
          escapePastedAtSymbols = true;
        };

        security.auth.selectedType = "oauth-personal";

        experimental = {
          enableAgents = true;
          taskTracker = true;
          jitContext = true;
          modelSteering = true;
          autoMemory = true;
          generalistProfile = true;
          contextManagement = true;
          directWebFetch = true;
        };

        telemetry.enabled = false;

        hooks = {
          SessionStart = [
            {
              hooks = [
                {
                  type = "command";
                  command = "${startSessionHook}";
                  name = "start";
                }
              ];
            }
          ];
        };
      };
    };

    home.sessionVariables = {
      GEMINI_CLI_HOME = "$HOME/.local/share/gemini";
      GEMINI_CLI_SYSTEM_SETTINGS_PATH = "$HOME/.gemini/settings.json";
      GEMINI_CLI_TRUST_WORKSPACE = "true";
    };
  };
}
