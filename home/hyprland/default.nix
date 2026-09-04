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

  rgb = c: "rgb(${removePrefix "#" c})";
  argb = c: "0xFF${removePrefix "#" c}";

  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkgs = inputs.hyprland.packages.${system};
  hyprlandPlugins = inputs.hyprland-plugins.packages.${system};
  hy3Pkgs = inputs.hy3.packages.${system};

  binds = import ./binds.nix { inherit lib; };

  wallpapers = {
    starfield-noise = toString ./wallpapers/starfield-noise.jpg;
    castle-gate-bonfire = toString ./wallpapers/castle-gate-bonfire.jpg;
    pixel-bonfire-city = toString ./wallpapers/pixel-bonfire-city.png;
    pixel-bonfire-tower = toString ./wallpapers/pixel-bonfire-tower.png;
    candle-circle-bonfire = toString ./wallpapers/candle-circle-bonfire.png;
  };
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
          bitdepth = mkOption {
            default = null;
            type = nullOr int;
          };
          cm = mkOption {
            default = null;
            type = nullOr str;
          };
        };
      });
    };

    wallpaper = mkOption {
      type = enum (attrNames wallpapers);
      default = "pixel-bonfire-city";
      description = "Which wallpaper to display via hyprpaper.";
    };
  };

  config = mkIf cfg.enable {
    services.hyprpaper = {
      enable = true;
      settings = {
        splash = false;
        preload = attrValues wallpapers;
        wallpaper = map (o: {
          monitor = o.output;
          path = wallpapers.${cfg.wallpaper};
          fit_mode = "fill";
        }) cfg.output;
      };
    };

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
        hy3Pkgs.hy3
        hyprbars
      ];

      configType = "lua";
      settings = {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 1;
            col = {
              active_border = palette.accent;
              inactive_border = palette.overlay;
              nogroup_border = palette.overlay;
              nogroup_border_active = palette.accent;
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
            shadow.enabled = false;
            inactive_opacity = 0.85;
            glow = {
              enabled = true;
              color = palette.accent;
              color_inactive = "rgba(00000000)";
            };
          };

          group = {
            col = {
              border_active = palette.accent;
              border_inactive = palette.overlay;
            };
            groupbar = {
              col = {
                active = palette.accent;
                inactive = palette.surface;
              };
            };
          };

          misc = {
            background_color = palette.bg;
            disable_hyprland_logo = true;
          };

          plugin = {
            hyprbars = {
              bar_height = 26;
              bar_color = palette.surface;
              bar_text_size = 13;
              bar_text_weight = "medium";
              bar_text_font = "JetBrainsMono Nerd Font";
              bar_text_align = "center";
              bar_part_of_window = true;
            };
          };

          xwayland = {
            use_nearest_neighbor = false;
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
          {
            _args = [
              {
                match = {
                  focus = true;
                };
                "hyprbars:title_color" = rgb palette.accent;
              }
            ];
          }
          {
            _args = [
              {
                match = {
                  focus = false;
                };
                "hyprbars:title_color" = rgb palette.muted;
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

        monitor = builtins.map (monitor: {
          _args = [ (filterAttrs (_: v: v != null) monitor) ];
        }) cfg.output;
      }
      // binds;
    };

    xdg.configFile."hypr/hyprtoolkit.conf".text = ''
      background = ${argb palette.bg}
      base = ${argb palette.surface}
      alternate_base = ${argb palette.raised}
      text = ${argb palette.text}
      bright_text = ${argb palette.bright}
      link_text = ${argb palette.blue}
      accent = ${argb palette.accent}
      accent_secondary = ${argb palette.accentAlt}
      rounding_large = 10
      rounding_small = 5
      font_family = Inter
      font_family_monospace = JetBrainsMono Nerd Font
    '';

    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = ''hyprctl dispatch "hl.dsp.dpms('on')"'';
          };

          listener = [
            {
              timeout = 600;
              on-timeout = "loginctl lock-session";
            }
            {
              timeout = 660;
              on-timeout = ''hyprctl dispatch "hl.dsp.dpms('off')"'';
              on-resume = ''hyprctl dispatch "hl.dsp.dpms('on')"'';
            }
          ];
        };
      };

      hyprlauncher = {
        enable = true;
        settings = {
          general = {
            grab_focus = true;
          };
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

          background = [
            { color = rgb palette.bg; }
          ];

          input-field = [
            {
              size = "320, 48";
              position = "0, -80";
              halign = "center";
              valign = "center";
              rounding = 4;
              outline_thickness = 2;
              outer_color = rgb palette.accent;
              inner_color = rgb palette.surface;
              font_color = rgb palette.text;
              check_color = rgb palette.accentAlt;
              fail_color = rgb palette.red;
              placeholder_text = "";
              fade_on_empty = false;
            }
          ];

          label = [
            {
              text = "$TIME";
              color = rgb palette.text;
              font_family = "Inter";
              font_size = 96;
              position = "0, 80";
              halign = "center";
              valign = "center";
            }
          ];
        };
      };

      waybar.systemd.targets = [ "hyprland-session.target" ];
    };

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
      gtk.enable = true;
      hyprcursor.enable = true;
    };
  };
}
