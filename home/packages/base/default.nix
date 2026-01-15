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
      git-lfs
      tree
      ncdu
      htop
      age
      sops
      zip
      unzip
      ntfs3g
    ];
  };
}
