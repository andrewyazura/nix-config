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
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          margin-top = 5;
          margin-left = 8;
          margin-right = 8;
          modules-left = [ "ext/workspaces" ];
          modules-center = [ ];
          modules-right = [
            "network"
            "pulseaudio"
            "clock"
            "battery"
          ];

          "ext/workspaces" = {
            on-click = "activate";
            format = "{name}";
            sort-by-name = false;
            sort-by-coordinates = true;
          };

          "clock" = {
            format = "{:%A, %B %d %H:%M}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
          };

          "pulseaudio" = {
            format = "{icon} {volume}%";
            format-muted = "🔇 muted";
            format-icons = [
              "🔈"
              "🔉"
              "🔊"
            ];
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

          "battery" = {
            format = "🔋 {capacity}%";
          };
        };
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-size: 16px;
          min-height: 0;
        }

        window#waybar {
          background: transparent;
          color: ${colors.text};
        }

        #workspaces, #network, #pulseaudio, #clock, #battery {
          background: alpha(${colors.surface}, 0.9);
          border: 1px solid ${colors.overlay};
          border-radius: 8px;
        }

        #workspaces {
          padding: 3px;
          margin: 0px 0 4px 6px;
        }

        #network, #pulseaudio, #clock, #battery {
          padding: 0 10px;
          margin: 4px 3px;
          color: ${colors.subtle};
        }

        #battery {
          margin-right: 6px;
        }

        #workspaces button {
          padding: 0 8px;
          border-radius: 6px;
          background: transparent;
          color: ${colors.muted};
        }

        #workspaces button:hover {
          background: ${colors.overlay};
          color: ${colors.text};
        }

        #workspaces button.active {
          background: ${colors.accent};
          color: ${colors.bg};
        }

        #workspaces button.urgent {
          background: ${colors.red};
          color: ${colors.bg};
        }

        #network {
          color: ${colors.accent};
        }

        #network.disconnected {
          color: ${colors.red};
        }

        #pulseaudio.muted {
          color: ${colors.muted};
        }

        #battery.warning {
          color: ${colors.yellow};
        }

        #battery.critical {
          color: ${colors.red};
        }
      '';
    };
  };
}
