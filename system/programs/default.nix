{ lib, config, pkgs, inputs, ... }:
with lib;
let cfg = config.modules.programs;
in {
  options.modules.programs = {
    enable = mkEnableOption "Enable programs configuration";
    enableMinecraft = mkEnableOption "Enable minecraft launcher";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        inputs.ghostty.packages.x86_64-linux.default

        bitwarden-desktop
        chromium
        discord
        firefox
        obs-studio
        obsidian
        signal-desktop
        spotify

        age
        git-lfs
        mpv
        ncdu
        ntfs3g
        sops
        tree
        unzip
        zip
      ] ++ lib.optionals cfg.enableMinecraft [ pkgs.prismlauncher ];
  };
}
