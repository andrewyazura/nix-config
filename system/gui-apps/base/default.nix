{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.gui-apps.base;
in
{
  options.modules.gui-apps.base = {
    enable = mkEnableOption "Enable base GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firefox
      chromium
      bitwarden-desktop
      inputs.ghostty.packages.x86_64-linux.default
    ];
  };
}
