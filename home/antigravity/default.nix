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
    home.packages = [ llm-agents.antigravity-cli ];
  };
}
