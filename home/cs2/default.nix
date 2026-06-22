{ lib, config, ... }:
with lib;
let
  cfg = config.modules.cs2;
in
{
  options.modules.cs2 = {
    enable = mkEnableOption "Enable CS2 configuration";
  };

  config = mkIf cfg.enable {
    home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/autoexec.cfg" = {
      source = ./autoexec.cfg;
    };
    home.file.".local/share/Steam/steamapps/common/Counter-Strike Global Offensive/game/csgo/cfg/practice.cfg" = {
      source = ./practice.cfg;
    };
  };
}
