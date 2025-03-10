{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.fonts;
in {
  options.modules.fonts = {
    enable = mkEnableOption "Enable fonts configuration";
  };

  config =
    mkIf cfg.enable { fonts.packages = with pkgs; [ nerd-fonts.fira-code ]; };
}
