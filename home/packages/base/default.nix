{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.packages.base;
in
{
  options.modules.packages.base = {
    enable = mkEnableOption "Enable base CLI packages";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      age
      fastfetch
      git-lfs
      htop
      ncdu
      ntfs3g
      sops
      tree
      unzip
      zip
    ];
  };
}
