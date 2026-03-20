{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.base-packages;
in
{
  options.modules.base-packages = {
    enable = mkEnableOption "Enable base CLI packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      age
      duf
      fastfetch
      fd
      git-lfs
      htop
      jq
      ncdu
      ntfs3g
      ripgrep
      sops
      tree
      unzip
      zip
    ];
  };
}
