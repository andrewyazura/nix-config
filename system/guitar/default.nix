{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.guitar;
in {
  options.modules.guitar = {
    enable = mkEnableOption "Enable guitar configuration";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ tonelib-gfx tonelib-jam qjackctl reaper  ];

    services.pipewire.jack.enable = true;
  };
}
