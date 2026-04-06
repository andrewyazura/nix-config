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
          checkpointing.enabled = true;

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
        };

        security.auth.selectedType = "oauth-personal";

        experimental = {
          enableAgents = true;
          taskTracker = true;
          jitContext = true;
          plan = true;
          modelSteering = true;
        };

        env = {
          GEMINI_TELEMETRY_ENABLED = "0";
        };
      };
    };
  };
}
