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
  gap = "<span letter_spacing='4608'> </span>";
  icon = glyph: "<span color='${colors.accent}'>${glyph}</span>${gap}";

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
    home.packages = [ pkgs.pwvucontrol ];

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
      };

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 34;
          margin-top = 8;
          margin-left = 10;
          margin-right = 10;
          modules-left = [ "ext/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [
            "hyprland/language"
            "network"
            "pulseaudio"
            "custom/power"
          ];

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
            format = "";
            sort-by-name = false;
            sort-by-coordinates = true;
          };

          "hyprland/language" = {
            format = "${icon "󰌌"}{}";
            format-en = "EN";
            format-uk = "UA";
          };

          "clock" = {
            format = "{:%a %d %b${gap}<span color='${colors.bright}' weight='500'>%H:%M</span>}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            calendar.format = {
              months = "<span color='${colors.text}'><b>{}</b></span>";
              weekdays = "<span color='${colors.subtle}'>{}</span>";
              today = "<span background='${colors.accent}' color='${colors.bg}'><b>{}</b></span>";
            };
          };

          "pulseaudio" = {
            format = "${icon "󰕾"}{volume}%";
            format-muted = "󰖁${gap}MUTED";
            on-click = "pwvucontrol";
          };

          "network" = {
            interface = "wlp4s0";
            format-wifi = "${icon "󰖩"}{essid}";
            format-ethernet = "<span color='${colors.accent}'>󰈀</span>";
            format-disconnected = "󰤭${gap}NOT CONNECTED";
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
          background: transparent;
          color: ${colors.text};
        }

        window#waybar > box {
          background: ${colors.bg};
          border: 1px solid ${colors.overlay};
          border-radius: 12px;
        }

        #workspaces {
          margin-left: 10px;
        }

        #workspaces button {
          min-width: 8px;
          min-height: 8px;
          padding: 0;
          margin: 12px 4px;
          border-radius: 4px;
          background: ${colors.muted};
          background-image: none;
          box-shadow: none;
        }

        #workspaces button label {
          font-size: 1px;
          min-height: 0;
          min-width: 0;
        }

        #workspaces button:hover {
          background: ${colors.subtle};
        }

        #workspaces button.active {
          min-width: 24px;
          background-image: linear-gradient(90deg, ${colors.accent}, ${colors.accentAlt});
        }

        #workspaces button.urgent {
          background: ${colors.red};
        }

        #language, #network, #pulseaudio, #clock, #custom-power {
          padding: 0 9px;
          color: ${colors.subtle};
        }

        #clock {
          color: ${colors.text};
        }

        #custom-power {
          margin-right: 6px;
        }

        #pulseaudio.muted {
          color: ${colors.muted};
        }

        #network.disconnected {
          margin: 6px 3px;
          border-radius: 8px;
          background: ${colors.red};
          color: ${colors.bg};
        }

        menu {
          background: ${colors.bg};
          border: 1px solid ${colors.overlay};
          border-radius: 10px;
          color: ${colors.text};
        }

        menuitem {
          padding: 4px 12px;
          border-radius: 6px;
        }

        menuitem:hover {
          background: ${colors.overlay};
          color: ${colors.bright};
        }

        tooltip {
          background: ${colors.bg};
          border: 1px solid ${colors.overlay};
          border-radius: 10px;
        }

        tooltip label {
          color: ${colors.text};
        }
      '';
    };
  };
}
