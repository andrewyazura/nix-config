{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.gui-apps.gaming;
in
{
  options.modules.gui-apps.gaming = {
    enable = mkEnableOption "Enable gaming GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      steam
    ];
  };
}
