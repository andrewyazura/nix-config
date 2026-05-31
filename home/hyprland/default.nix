{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.hyprland;
  palette = import ../../common/colors.nix;

  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkgs = inputs.hyprland.packages.${system};
  hyprlandPlugins = inputs.hyprland-plugins.packages.${system};
  hy3Pkgs = inputs.hy3.packages.${system};

  binds = import ./binds.nix { inherit lib; };
in
{
  options.modules.hyprland = with types; {
    enable = mkEnableOption "Enable hyprland configuration";

    output = mkOption {
      default = [ ];
      type = listOf (submodule {
        options = {
          output = mkOption { type = str; };
          mode = mkOption { type = str; };
          position = mkOption { type = str; };
          scale = mkOption {
            default = 1.0;
            type = float;
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      grim
      playerctl
      slurp
      wl-clipboard
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;

      plugins = with hyprlandPlugins; [
        csgo-vulkan-fix
        hy3Pkgs.hy3
      ];

      configType = "lua";
      settings = {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            col = {
              active_border = palette.mauve;
              inactive_border = palette.base;
              nogroup_border = palette.base;
              nogroup_border_active = palette.mauve;
            };

            no_focus_fallback = true;
            resize_on_border = true;
            layout = "hy3";
            allow_tearing = true;
          };

          decoration = {
            rounding = 10;
            rounding_power = 4.0;
            blur.enabled = true;
            shadow = {
              enabled = true;
              color = palette.base;
            };
            glow = {
              enabled = true;
              color = palette.mauve;
            };
          };

          group = {
            col = {
              border_active = palette.mauve;
              border_inactive = palette.base;
            };
            groupbar = {
              col = {
                active = palette.mauve;
                inactive = palette.base;
              };
            };
          };

          input = {
            kb_layout = "us,ua";
            kb_options = "grp:win_space_toggle,caps:swapescape";
            follow_mouse = 2;
            force_no_accel = true;
            sensitivity = 0;
          };
        };

        window_rule = [
          {
            _args = [
              {
                match = {
                  class = "cs2";
                };
                immediate = true;
              }
            ];
          }
        ];

        device = [
          {
            _args = [
              {
                name = "wooting-wooting-60he+";
                kb_options = "grp:win_space_toggle";
                kb_layout = "us,ua";
              }
            ];
          }
          {
            _args = [
              {
                name = "sonix-usb-device";
                kb_options = "grp:win_space_toggle";
                kb_layout = "us,ua";
              }
            ];
          }
        ];

        monitor = builtins.map (monitor: { _args = [ monitor ]; }) cfg.output;
      }
      // binds;
    };

    services = {
      hyprlauncher = {
        enable = true;
        settings = {
          general = {
            grab_focus = true;
          };
        };
      };

      hyprpaper = {
        enable = true;
        settings = {
          wallpaper =
            let
              wallpaperPath = ../../common/wallpapers/nix-black-4k.png;
            in
            [
              "DP-1,${wallpaperPath}"
              "DP-2,${wallpaperPath}"
            ];
        };
      };
    };

    programs = {
      hyprlock = {
        enable = true;
        settings = {
          general = {
            hide_cursor = false;
            ignore_empty_input = true;
          };
        };
      };

      waybar.systemd.targets = [ "hyprland-session.target" ];
    };

    home.pointerCursor = {
      package = pkgs.apple-cursor;
      name = "macOS";
      size = 24;
      gtk.enable = true;
      hyprcursor.enable = true;
    };
  };
}
