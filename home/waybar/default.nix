{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.modules.waybar;
  colors = import ../../common/colors.nix;
in {
  options.modules.waybar = { enable = mkEnableOption "Enable waybar"; };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 35;
          modules-left = [ "sway/workspaces" ];
          modules-center = [ ];
          modules-right = [ "network" "pulseaudio" "clock" "battery" ];

          "sway/workspaces" = {
            disable-scroll = true;
            all-outputs = true;
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
            format-wifi = "{essid} {downspeed:7} ";
            format-ethernet = "{ifname} {downspeed:7} ";
            format-disconnected = "not connected";
            tooltip-format = "{ifname} via {gwaddr} ";
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
          background: ${colors.base};
          color: ${colors.text};
        }

        #workspaces button {
          padding: 0 5px;
          background: transparent;
          color: ${colors.text};
        }

        #workspaces button.active {
          color: ${colors.mauve};
        }

        #workspaces button:hover {
          box-shadow: inherit;
          text-shadow: inherit;
        }

        #workspaces button:hover {
          background: ${colors.surface0};
          border: none;
          padding: 0 5px;
          color: ${colors.mauve};
        }

        #mode {
          background: ${colors.surface0};
          border-bottom: 2px solid ${colors.crust};
          color: ${colors.mauve};
          padding: 0 5px;
        }

        #clock, #pulseaudio, #network, #cpu, #memory, #backlight, #tray {
          padding: 0 10px;
          color: ${colors.text};
        }
      '';
    };
  };
}
