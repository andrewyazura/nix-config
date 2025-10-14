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
        extraPackages = with pkgs; [
          grim
          mako
          playerctl
          slurp
          waylock
          wl-clipboard
        ];
      };

      ssh.startAgent = true;
    };

    services = {
      gnome.gcr-ssh-agent.enable =
        false; # required when programs.ssh.startAgent = true
      playerctld.enable = true;

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet -r --time --cmd sway";
          };
        };
      };
    };

    systemd.services.greetd = {
      serviceConfig.Type = "idle";
      unitConfig.After = mkForce [ "multi-user.target" ];
    };

    security.pam.services.waylock = {
      text = ''
        auth     include login
        account  include login
      '';
    };
  };
}
