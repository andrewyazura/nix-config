{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.sway;
in {
  options.modules.sway = {
    enable = mkEnableOption "Enable sway configuration";
  };

  config = mkIf cfg.enable {
    programs = {
      sway = {
        enable = true;
        wrapperFeatures.gtk = true;
        extraPackages = with pkgs; [ mako grim slurp swaylock wl-clipboard ];
      };

      ssh = { startAgent = true; };
    };

    environment.shellInit = "eval $(gnome-keyring-daemon --start 2>/dev/null)";

    services = {
      gnome.gnome-keyring.enable = true;
      greetd = {
        enable = true;
        settings = {
          default_session = {
            command =
              "${pkgs.greetd.tuigreet}/bin/tuigreet -r --time --cmd sway";
          };
        };
      };
    };
  };
}
