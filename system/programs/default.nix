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

      bitwarden-cli
      discord
      obsidian
      signal-desktop
      spotify

      git-lfs
      tree

      chromium
      firefox
    ];
  };
}
