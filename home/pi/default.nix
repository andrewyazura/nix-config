{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.pi;
  system = pkgs.stdenv.hostPlatform.system;
  llm-agents = inputs.llm-agents.packages.${system};
in
{
  options.modules.pi = {
    enable = mkEnableOption "Enable pi configuration";
  };

  config = mkIf cfg.enable {
    home.packages = [ llm-agents.pi ];
  };
}
