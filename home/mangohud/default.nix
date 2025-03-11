{ lib, config, ... }:
with lib;
let cfg = config.modules.mangohud;
in {
  options.modules.mangohud = {
    enable = mkEnableOption "Enable MangoHud configuration";
  };

  config = mkIf cfg.enable {
    home.file.".config/MangoHud/MangoHud.conf".source = ./MangoHud.conf;
    home.file.".config/MangoHud/presets.conf".source = ./presets.conf;
  };
}
