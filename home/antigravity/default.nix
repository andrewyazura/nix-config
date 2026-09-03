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

  hooks = import ./hooks.nix { inherit lib pkgs; };
  jsonFormat = pkgs.formats.json { };
in
{
  options.modules.antigravity = {
    enable = mkEnableOption "Enable antigravity configuration";
  };

  config = mkIf cfg.enable {
    programs.antigravity-cli = {
      enable = true;
      package = llm-agents.antigravity-cli;
      defaultModel = "gemini-3.8-flash-high";
      enableMcpIntegration = true;

      context = {
        GEMINI = ../../common/llm-memory.md;
      };

      skills = ../claude/skills;

      settings = {
        model = "Gemini 3.8 Flash (High)";
        notifications = true;
        runningLightSpeed = "fast";
        toolPermission = "always-proceed";
      };
    };

    home.file = {
      ".gemini/config/hooks.json" = {
        source = jsonFormat.generate "antigravity-hooks.json" hooks;
        force = true;
      };
      ".gemini/antigravity-cli/settings.json".force = true;
    };
  };
}
