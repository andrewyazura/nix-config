{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.gaming;
in
{
  options.modules.gaming = {
    enable = mkEnableOption "Enable gaming GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      steam
    ];
  };
}
