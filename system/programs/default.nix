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
        bitwarden-desktop
        chromium
        discord
        firefox
        gemini-cli
        obs-studio
        obsidian
        signal-desktop
        spotify

        age
        fastfetch
        git-lfs
        mpv
        ncdu
        ntfs3g
        sops
        tree
        unzip
        zip
      ] ++ lib.optionals cfg.enableMinecraft [ pkgs.prismlauncher ]
      ++ lib.optionals (pkgs.system == "x86_64-linux")
      [ inputs.ghostty.packages.x86_64-linux.default ];
  };
}
