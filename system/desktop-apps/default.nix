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
      inputs.llm-agents.packages.x86_64-linux.claude-desktop

      antigravity-hub
      google-chrome
      obsidian
      proton-vpn-cli
      qbittorrent
      signal-desktop
      spotifast
      telegram-desktop
    ];
  };
}
