{ lib, config, ... }:
with lib;
let cfg = config.modules.waybar;
in {
  options.modules.waybar = {
    enable = mkEnableOption "Enable waybar configuration";
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 16;

          modules-left = [ "sway/workspaces" ];
          modules-center = [ ];
          modules-right = [ "network#lan" "network#wifi" "pulseaudio" "clock" ];
        };

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
        };

        pulseaudio = {
          format = "{volume}%";
          format-muted = "muted";
        };

        clock = {
          interval = 1;
          format = "{:%A, %B %d %H:%M}";
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };

        "network#wifi" = {
          interface = "wlp4s0";
          format-wifi = "{signalStrength}% {essid} {downspeed:7}";
          format-ethernet = "";
          format-linked = "{ifname} (no ip)";
          format-disconnected = "not connected";
        };

        "network#lan" = {
          interface = "enp9s0";
          format-wifi = "";
          format-ethernet = "{ifname} {downspeed:7}";
          format-linked = "{ifname} (no ip)";
          format-disconnected = "";
        };
      };

      style = let
        colors = import ../../common/colors.nix;
        waybarCss = readFile ./waybar.css;
      in ''
        ${concatStringsSep "\n"
        (mapAttrsToList (name: value: "@define-color ${name} ${value};")
          colors)}

        ${waybarCss}
      '';
    };
  };
}
