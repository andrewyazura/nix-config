{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.waybar;
  colors = import ../../common/colors.nix;
in
{
  options.modules.waybar = {
    enable = mkEnableOption "Enable waybar";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "sway-session.target";
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 24;
          modules-left = [ "sway/workspaces" ];
          modules-center = [ ];
          modules-right = [
            "network"
            "pulseaudio"
            "clock"
            "battery"
          ];

          "sway/workspaces" = {
            disable-scroll = true;
            format = "{name}";
          };

          "clock" = {
            format = "{:%A, %B %d %H:%M}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };

          "pulseaudio" = {
            format = "{volume}%";
            format-muted = "muted";
            on-click = "pavucontrol";
          };

          "network" = {
            interface = "wlp4s0";
            format-wifi = "{icon} {essid} {bandwidthDownBytes}";
            format-ethernet = "{ifname} {bandwidthDownBytes}";
            format-disconnected = "not connected";
            tooltip-format = "{ipaddr}";

            format-icons = [
              "▁"
              "▂"
              "▃"
              "▅"
              "▇"
              "█"
            ];
          };
        };
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "Adwaita Mono Nerd Font";
          font-size: 14px;
          min-height: 0;
        }

        window#waybar {
          background: ${colors.crust};
          color: ${colors.text};
        }

        #workspaces button {
          padding: 0 5px;
          background: transparent;
        }

        #workspaces button.active, #workspaces button.visible {
          background: ${colors.mauve};
          color: ${colors.base};
        }

        #workspaces button.urgent {
          background: ${colors.red};
          color: ${colors.base};
        }

        #clock, #pulseaudio, #network, #cpu, #memory, #backlight, #tray {
          margin-right: 10px;
        }

        #network {
          color: ${colors.mauve};
        }

        #network.disconnected {
          background: ${colors.red};
          color: ${colors.base};
        }
      '';
    };
  };
}
