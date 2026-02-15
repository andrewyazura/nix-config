{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.desktop-apps;
in
{
  options.modules.desktop-apps = {
    enable = mkEnableOption "Enable desktop GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.ghostty.packages.x86_64-linux.default

      bitwarden-desktop
      chromium
      firefox

      discord
      signal-desktop
      vesktop

      obs-studio
      obsidian
      spotify
    ];
  };
}
