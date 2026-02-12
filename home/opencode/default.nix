{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.opencode;
  system = pkgs.stdenv.hostPlatform.system;
  opencode-package = inputs.opencode.packages.${system}.default;
in
{
  options.modules.opencode = {
    enable = mkEnableOption "Enable Opencode configuration";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
      package = opencode-package;
    };
  };
}
