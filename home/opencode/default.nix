{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.opencode;
in
{
  options.modules.opencode = {
    enable = mkEnableOption "Enable Opencode configuration";
  };

  config = mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;
    };
  };
}
