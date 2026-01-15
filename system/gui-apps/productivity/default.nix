{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.gui-apps.productivity;
in
{
  options.modules.gui-apps.productivity = {
    enable = mkEnableOption "Enable productivity GUI applications";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      obsidian
    ];
  };
}
