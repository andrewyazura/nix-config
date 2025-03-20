{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.i3;
in {
  options.modules.i3 = { enable = mkEnableOption "Enable i3 configuration"; };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        windowManager.i3.enable = true;
      };

      libinput.enable = true;
      gnome.gnome-keyring.enable = true;
      displayManager = { defaultSession = "none+i3"; };
    };

    environment = {
      systemPackages = with pkgs; [ dconf xclip ];
      shellInit = "eval $(gnome-keyring-daemon --start 2>/dev/null)";
    };

    programs.ssh = { startAgent = true; };
  };
}
