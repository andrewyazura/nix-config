{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.guitar;
in {
  options.modules.guitar = {
    enable = mkEnableOption "Enable guitar recording software and plugins";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      reaper
      neural-amp-modeler-lv2
      calf
      lsp-plugins
      alsa-scarlett-gui
      qpwgraph
    ];
  };
}
