{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.wivrn;
in
{
  options.modules.wivrn = {
    enable = mkEnableOption "Enable WiVRn";
  };

  config = mkIf cfg.enable {
    services.wivrn = {
      enable = true;
      openFirewall = true;
    };
  };
}
