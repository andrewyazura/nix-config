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

  keyboardLayout = pkgs.writeShellScript "waybar-keyboard-layout" ''
    keyboard=$(hyprctl -j devices | ${pkgs.jq}/bin/jq '.keyboards[] | select(.main == true)')
    name=$(echo "$keyboard" | ${pkgs.jq}/bin/jq -r '.name')
    index=$(echo "$keyboard" | ${pkgs.jq}/bin/jq -r '.active_layout_index')
    layout=$(echo "$keyboard" | ${pkgs.jq}/bin/jq -r '.layout' | cut -d, -f$((index + 1)))

    case "$layout" in
      us) text="🇬🇧 en" ;;
      ua) text="🇺🇦 ua" ;;
      *) text="$layout" ;;
    esac

    ${pkgs.jq}/bin/jq -nc --arg text "$text" --arg tooltip "$name" '{text: $text, tooltip: $tooltip}'
  '';

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
          height = 32;
          margin-top = 5;
          margin-left = 8;
          margin-right = 8;
          modules-left = [
            "custom/launcher"
            "ext/workspaces"
          ];
          modules-center = [ ];
          modules-right = [
            "custom/keyboard-layout"
            "network"
            "pulseaudio"
            "clock"
            "battery"
            "custom/power"
          ];

          "custom/launcher" = {
            format = "";
            tooltip = false;
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

          "custom/keyboard-layout" = {
            exec = "${keyboardLayout}";
            interval = 1;
            return-type = "json";
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
            format-wifi = "{essid} {bandwidthDownBytes}";
            format-ethernet = "󰈀 {ifname} {bandwidthDownBytes}";
            format-disconnected = "󰤭 not connected";
            tooltip-format = "{ipaddr}";
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

        #custom-launcher, #workspaces, #custom-keyboard-layout, #network, #pulseaudio, #clock, #battery, #custom-power {
          background: alpha(${colors.surface}, 0.9);
          border: 1px solid ${colors.overlay};
          border-radius: 8px;
        }

        #workspaces {
          padding: 3px;
          margin: 0px 0 4px 0px;
        }

        #custom-keyboard-layout, #network, #pulseaudio, #clock, #battery, #custom-power {
          padding: 0 10px;
          margin: 4px 3px;
          color: ${colors.subtle};
        }

        #custom-launcher {
          padding: 0 15px 0 9px;
          margin: 0px 3px 4px 6px;
          color: ${colors.accent};
        }

        #custom-power {
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

        menu {
          background: ${colors.surface};
          border: 1px solid ${colors.overlay};
          border-radius: 8px;
          color: ${colors.text};
        }

        menuitem {
          padding: 4px 12px;
          border-radius: 6px;
        }

        menuitem:hover {
          background: ${colors.accent};
          color: ${colors.bg};
        }
      '';
    };
  };
}
