{ lib, config, pkgs, inputs, ... }:
with lib;
let cfg = config.modules.programs;
in {
  options.modules.programs = {
    enable = mkEnableOption "Enable programs configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.ghostty.packages.x86_64-linux.default

      obsidian
      spotify
      telegram-desktop
      vesktop # fixed screensharing

      btop
      git-crypt
      mpv

      chromium
      firefox
    ];
  };
}
