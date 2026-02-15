{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.karabiner;
in
{
  options.modules.karabiner = {
    enable = mkEnableOption "Enable karabiner-elements service";
  };

  config = mkIf cfg.enable {
    services.karabiner-elements.enable = true;
  };
}
