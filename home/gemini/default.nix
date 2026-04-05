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
  gemini-package = inputs.llm-agents.packages.${system}.gemini-cli;
in
{
  options.modules.gemini = {
    enable = mkEnableOption "Enable gemini configuration";
  };

  config = mkIf cfg.enable {
    programs.gemini-cli = {
      enable = true;
      package = gemini-package;
      settings = {
        general = {
          sessionRetention = {
            warningAcknowledged = true;
            enabled = true;
            maxAge = "120d";
          };
          vimMode = false;
          enableNotifications = true;
        };
        security.auth.selectedType = "oauth-personal";
        ui = {
          showMemoryUsage = true;
          showCitations = true;
          showModelInfoInChat = true;
          showUserIdentity = true;
          loadingPhrases = "all";
        };
        experimental.plan = true;
      };
    };
  };
}
