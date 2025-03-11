{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.sway;
in {
  options.modules.sway = {
    enable = mkEnableOption "Enable sway configuration";
  };

  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      extraPackages = with pkgs; [
        mako
        slurp
        swayidle
        swaylock
        tofi
        wl-clipboard
      ];
    };
  };
}
