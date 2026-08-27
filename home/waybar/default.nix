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
          height = 24;
          modules-left = [ "hyprland/workspaces" ];
          modules-center = [ ];
          modules-right = [
            "network"
            "pulseaudio"
            "clock"
            "battery"
          ];

          "hyprland/workspaces" = {
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
          font-family: "JetBrainsMono Nerd Font";
          font-size: 14px;
          min-height: 0;
        }

        window#waybar {
          background: ${colors.bg};
          color: ${colors.text};
        }

        #workspaces button {
          padding: 0 8px;
          background: transparent;
          color: ${colors.muted};
        }

        #workspaces button.active, #workspaces button.visible {
          color: ${colors.accent};
          box-shadow: inset 0 -2px ${colors.accent};
        }

        #workspaces button.urgent {
          color: ${colors.red};
          box-shadow: inset 0 -2px ${colors.red};
        }

        #clock, #pulseaudio, #network, #battery {
          margin-right: 12px;
          color: ${colors.subtle};
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
