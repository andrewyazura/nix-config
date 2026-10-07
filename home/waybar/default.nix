{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.waybar;
  colors = import ../../common/colors.nix;

  powerMenu = pkgs.writeText "waybar-power-menu.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <interface>
      <object class="GtkMenu" id="menu">
        <child>
          <object class="GtkMenuItem" id="lock">
            <property name="label">Lock</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="suspend">
            <property name="label">Suspend</property>
          </object>
        </child>
        <child>
          <object class="GtkSeparatorMenuItem" id="separator" />
        </child>
        <child>
          <object class="GtkMenuItem" id="reboot">
            <property name="label">Reboot</property>
          </object>
        </child>
        <child>
          <object class="GtkMenuItem" id="shutdown">
            <property name="label">Shut down</property>
          </object>
        </child>
      </object>
    </interface>
  '';
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
          height = 35;
          modules-left = [
            "custom/launcher"
            "ext/workspaces"
          ];
          modules-center = [ ];
          modules-right = [
            "hyprland/language"
            "network"
            "pulseaudio"
            "clock"
            "custom/power"
          ];

          "custom/launcher" = {
            format = "YoRHa";
            tooltip-format = "Open launcher: Alt+Space";
            on-click = "hyprlauncher";
          };

          "custom/power" = {
            format = "󰐥";
            tooltip = false;
            menu = "on-click";
            menu-file = "${powerMenu}";
            menu-actions = {
              lock = "loginctl lock-session";
              suspend = "systemctl suspend";
              reboot = "systemctl reboot";
              shutdown = "systemctl poweroff";
            };
          };

          "ext/workspaces" = {
            on-click = "activate";
            format = "{name}";
            sort-by-name = false;
            sort-by-coordinates = true;
          };

          "hyprland/language" = {
            format = "󰌌 {}";
            format-en = "EN";
            format-uk = "UA";
          };

          "clock" = {
            format = "󰥔 {:%a %d %b %H:%M}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            calendar.format = {
              months = "<span color='${colors.text}'><b>{}</b></span>";
              weekdays = "<span color='${colors.subtle}'>{}</span>";
              today = "<span background='${colors.text}' color='${colors.bg}'><b>{}</b></span>";
            };
          };

          "pulseaudio" = {
            format = "󰕾 {volume}%";
            format-muted = "󰖁 MUTED";
            on-click = "pavucontrol";
          };

          "network" = {
            interface = "wlp4s0";
            format-wifi = "󰖩";
            format-ethernet = "󰈀";
            format-disconnected = "󰤭 NOT CONNECTED";
            tooltip-format = "{essid}\n{ipaddr}\n{bandwidthDownBytes} down";
          };
        };
      };

      style = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "Noto Sans CJK JP", "JetBrainsMono Nerd Font Propo";
          font-size: 15px;
          min-height: 0;
        }

        window#waybar {
          background: alpha(${colors.surface}, 0.94);
          border-bottom: 1px solid ${colors.text};
          color: ${colors.text};
        }

        #custom-launcher, #workspaces button {
          background: ${colors.bg};
          color: ${colors.text};
          box-shadow: 3px 3px 0 alpha(black, 0.4);
        }

        #custom-launcher {
          padding: 0 14px;
          margin: 5px 10px 7px 8px;
          font-weight: 500;
          letter-spacing: 2px;
        }

        #workspaces button {
          padding: 0 12px;
          margin: 5px 3px 7px 3px;
        }

        #custom-launcher:hover, #workspaces button:hover {
          background: ${colors.raised};
        }

        #workspaces button.active {
          background: ${colors.text};
          color: ${colors.bg};
        }

        #workspaces button.urgent, #network.disconnected {
          background: ${colors.red};
          color: ${colors.bg};
        }

        #network.disconnected {
          margin: 5px 3px 7px 3px;
        }

        #language, #network, #pulseaudio, #clock, #custom-power {
          padding: 0 10px;
          color: ${colors.text};
          letter-spacing: 1px;
        }

        #language {
          letter-spacing: 0;
        }

        #clock {
          font-weight: 500;
        }

        #custom-power {
          margin-right: 6px;
        }

        #pulseaudio.muted {
          color: ${colors.subtle};
        }

        menu {
          background: ${colors.bg};
          border: 1px solid ${colors.text};
          color: ${colors.text};
        }

        menuitem {
          padding: 4px 12px;
        }

        menuitem:hover {
          background: ${colors.text};
          color: ${colors.bg};
        }

        tooltip {
          background: ${colors.bg};
          border: 1px solid ${colors.text};
          border-radius: 0;
        }

        tooltip label {
          color: ${colors.text};
        }
      '';
    };
  };
}
