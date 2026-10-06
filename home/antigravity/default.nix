{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.antigravity;
  system = pkgs.stdenv.hostPlatform.system;
  llm-agents = inputs.llm-agents.packages.${system};
in
{
  options.modules.antigravity = {
    enable = mkEnableOption "Enable antigravity configuration";
  };

  config = mkIf cfg.enable {
    programs.antigravity-cli = {
      enable = true;
      enableMcpIntegration = true;
      mutableSettings = true;

      package = llm-agents.antigravity-cli;
      context.AGENTS = ../../common/llm-memory.md;

      settings = {
        altScreenMode = "never";
        artifactReviewPolicy = "agent-decides";
        colorScheme = "terminal";
        editor = "nvim";
        editorMode = "vim";
        model = "Gemini 3.8 Flash (High)";
        notifications = true;
        pickerGrouping = "grouped";
        queuedMessages = "queue";
        runningLightSpeed = "fast";
        showFeedbackSurvey = false;
        showTips = false;
        toolPermission = "always-proceed";
        verbosity = "medium";
      };

      permissions = {
        allow = [
          "command(*)"
          "read_file(*)"
          "write_file(*)"
          "mcp(*)"
          "read_url(*)"
          "execute_url(*)"
        ];
      };
    };
  };
}
