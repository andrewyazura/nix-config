{ lib, config, ... }:
with lib;
let cfg = config.modules.minegrub;
in {
  options.modules.minegrub = {
    enable = mkEnableOption "Enable minegrub configuration";
  };

  config = mkIf cfg.enable {
    boot.loader.grub = {
      minegrub-theme = {
        enable = true;
        boot-options-count = 10;
        background = "background_options/1.8  - [Classic Minecraft].png";
      };
    };
  };
}
