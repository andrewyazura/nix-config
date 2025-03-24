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
          background = "#111";
          background-alt = "#444";

          foreground = "#ddd";
          foreground-alt = "#555";

          primary = "#ffb52a";
          secondary = "#e60053";
          alert = "#bd2c40";
          accent = "#4bc98a";
        };
      in {
        "bar/top" = {
          width = "100%";
          height = 24;

          radius = 0;
          line-size = 0;
          border-size = 0;

          background = "${colors.background}";
          foreground = "${colors.foreground}";

          modules-left = "i3";
          modules-center = "";
          modules-right = "date battery";

          module-margin-left = 1;
          module-margin-right = 2;

          padding-left = 0;
          padding-right = 2;

          font-0 = "Fira Code:pixelsize=10;0";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          index-sort = true;
          wrapping-scroll = false;

          pin-workspaces = false;

          label-mode-padding = 2;
          label-mode-foreground = "#000";
          label-mode-background = "${colors.primary}";

          label-focused = "%name%";
          label-focused-background = "${colors.accent}";
          label-focused-underline = "${colors.background}";
          label-focused-foreground = "${colors.background}";
          label-focused-padding = 2;

          label-unfocused = "%name%";
          label-unfocused-padding = 2;

          label-visible = "%name%";
          label-visible-background = "${colors.accent}";
          label-visible-underline = "${colors.background}";
          label-visible-padding = 2;

          label-urgent = "%name%";
          label-urgent-background = "${colors.alert}";
          label-urgent-underline = "${colors.background}";
          label-urgent-padding = 2;
        };

        "module/date" = {
          type = "internal/date";
          interval = 1;

          date = "%Y-%m-%d";
          date-alt = "";

          time = "%H:%M";
          time-alt = "%H:%M:%S";

          label = "%date% %time%";
        };

        "module/battery" = {
          type = "internal/battery";
          full-at = 99;
          low-at = 20;

          battery = "BAT0";
          adapter = "AC0";
          poll-interval = 10;
        };
      };
    };
  };
}
