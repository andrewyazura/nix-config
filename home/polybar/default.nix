{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.polybar;
in {
  options.modules.polybar = {
    enable = mkEnableOption "Enable polybar configuration";
  };

  config = mkIf cfg.enable {
    services.polybar = {
      enable = true;
      script = "polybar top &";
      package = pkgs.polybar.override { i3Support = true; };

      config = let
        colors = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
          transparent = "#FF00000";
        };
      in {
        "bar/top" = {
          width = "100%";
          height = 16;

          radius = 0;
          line-size = 0;
          border-size = 0;

          background = "${colors.base}";
          foreground = "${colors.text}";

          modules-left = "i3";
          modules-center = "";
          modules-right = "wifi date battery";

          module-margin-left = 2;
          module-margin-right = 2;

          padding-left = 0;
          padding-right = 0;

          font-0 = "Fira Code Nerd Font:pixelsize=10;2";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;

          pin-workspaces = true;

          label-mode-foreground = "#000";
          label-mode-background = "${colors.blue}";
          label-mode-padding = 1;

          label-focused = "%name%";
          label-focused-background = "${colors.mauve}";
          label-focused-underline = "${colors.base}";
          label-focused-foreground = "${colors.base}";
          label-focused-padding = 1;

          label-unfocused = "%name%";
          label-unfocused-padding = 1;

          label-visible = "%name%";
          label-visible-background = "${colors.mauve}";
          label-visible-underline = "${colors.base}";
          label-visible-padding = 1;

          label-urgent = "%name%";
          label-urgent-background = "${colors.red}";
          label-urgent-underline = "${colors.base}";
          label-urgent-padding = 1;
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;

          date = "%A, %B %d";
          date-alt = "%Y-%m-%d";

          time = "%H:%M";
          time-alt = "%H:%M:%S";

          label = "%date% %time%";
        };

        "module/battery" = let label = "%percentage%%";
        in {
          type = "internal/battery";

          full-at = 99;
          low-at = 20;

          battery = "BAT0";
          adapter = "AC0";

          format-full = "<ramp-capacity> <label-full>";
          format-full-background = "${colors.base}";
          format-full-foreground = "${colors.green}";

          format-charging = "<ramp-capacity> <label-charging>";
          format-charging-background = "${colors.base}";
          format-charging-foreground = "${colors.green}";

          format-discharging = "<ramp-capacity> <label-discharging>";
          format-discharging-background = "${colors.base}";
          format-discharging-foreground = "${colors.mauve}";

          format-low = "<ramp-capacity> <label-low>";
          format-low-background = "${colors.base}";
          format-low-foreground = "${colors.red}";

          label-full = label;
          label-charging = label;
          label-discharging = label;
          label-low = label;

          ramp-capacity-0 = "▁";
          ramp-capacity-1 = "▂";
          ramp-capacity-2 = "▃";
          ramp-capacity-3 = "▅";
          ramp-capacity-4 = "▇";
          ramp-capacity-5 = "█";
        };

        "module/wifi" = {
          type = "internal/network";
          interface = "wlp2s0";
          interface-type = "wireless";

          format-connected = "<ramp-signal> <label-connected>";
          format-disconnected = "<label-disconnected>";

          label-connected = "%essid% %downspeed:9%";
          label-connected-foreground = "${colors.mauve}";

          label-disconnected = "not connected";
          label-disconnected-background = "${colors.red}";
          label-disconnected-foreground = "${colors.text}";

          ramp-signal-0 = "▁";
          ramp-signal-1 = "▂";
          ramp-signal-2 = "▃";
          ramp-signal-3 = "▅";
          ramp-signal-4 = "▇";
          ramp-signal-5 = "█";
        };
      };
    };
  };
}
