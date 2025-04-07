{ lib, config, ... }:
with lib;
let cfg = config.modules.waybar;
in {
  options.modules.waybar = {
    enable = mkEnableOption "Enable waybar configuration";
    output = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Specify on which screen this bar will be displayed
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          output = cfg.output;
          height = 24;

          modules-left = [ "sway/workspaces" ];
          modules-right = [ "network" "clock" ];
        };

        "sway/workspaces" = {
          disable-scroll = true;
          format = "{icon}";
          all-outputs = true;
        };

        clock = {
          interval = 1;
          format = "{:%A, %B %d %H:%M}";
          tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
        };

        network = {
          format-wifi = "{essid} {signalStrength}% {bandwidthDownBits}bps";
          format-ethernet = "{ifname}/{ipaddr} {bandwidthDownBits}bps";
          format-disconnected = "not connected";
          tooltip-format = "{ifname} - {ipaddr}";
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
