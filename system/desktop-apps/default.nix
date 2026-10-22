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
    environment.systemPackages =
      with pkgs;
      [
        google-chrome
        obsidian
        proton-vpn-cli
        qbittorrent
        signal-desktop
        spotify
        telegram-desktop
      ]
      ++ (with inputs; [
        ghostty.packages.x86_64-linux.default
        llm-agents.packages.x86_64-linux.antigravity-hub
        llm-agents.packages.x86_64-linux.claude-desktop
        spotifast.packages.x86_64-linux.spotifast
      ]);
  };
}
