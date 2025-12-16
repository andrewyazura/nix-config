{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.gnome;
in {
  options.modules.gnome = {
    enable = mkEnableOption "Enable gnome configuration";
  };

  config = mkIf cfg.enable {
    services = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      gnome = {
        games.enable = false;
        gcr-ssh-agent.enable = false;
      };
    };

    environment = {
      systemPackages = with pkgs; [ dconf gnomeExtensions.pop-shell ];
    };
  };
}
