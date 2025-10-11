{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.polybar;
in {
  options.modules.polybar = {
    enable = mkEnableOption "Enable polybar configuration";
  };

  config = mkIf cfg.enable {
    xsession.windowManager.i3.config.startup = [{
      command = "systemctl --user restart polybar.service";
      always = true;
    }];

    services.polybar = {
      enable = true;
      script = "polybar top &";
      package = pkgs.polybar.override {
        i3Support = true;
        pulseSupport = true;
      };

      config = let colors = import ../../common/colors.nix;
      in {
        "bar/top" = {
          width = "100%";
          height = 16;

          radius = 0;
          line-size = 0;
          border-size = 0;

          background = "${colors.crust}";
          foreground = "${colors.text}";

          modules-left = "i3";
          modules-center = "";
          modules-right = "lan wifi volume date battery";

          module-margin-left = 2;
          module-margin-right = 2;

          padding-left = 0;
          padding-right = 0;

          font-0 = "Adwaita Mono Nerd Font:pixelsize=10;2";
        };

        "module/volume" = {
          type = "internal/pulseaudio";

          format-volume = "<label-volume>";
          label-volume = "%percentage%%";

          format-muted = "muted";
          format-muted-background = "${colors.red}";
          format-muted-foreground = "${colors.base}";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;

          pin-workspaces = true;

          label-mode-foreground = "${colors.text}";
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

        "module/lan" = {
          type = "internal/network";
          interface = "enp4s0f3u1";
          interface-type = "wired";

          format-connected = "<label-connected>";
          format-disconnected = "";

          label-connected = "%ifname% %downspeed:7%";
          label-connected-foreground = "${colors.mauve}";
        };

        "module/wifi" = {
          type = "internal/network";
          interface = "wlp2s0";
          interface-type = "wireless";

          format-connected = "<ramp-signal> <label-connected>";
          format-disconnected = "<label-disconnected>";

          label-connected = "%essid% %downspeed:7%";
          label-connected-foreground = "${colors.mauve}";

          label-disconnected = "not connected";
          label-disconnected-background = "${colors.red}";
          label-disconnected-foreground = "${colors.base}";

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
