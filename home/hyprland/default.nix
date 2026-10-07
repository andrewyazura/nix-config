{
  lib,
  config,
  pkgs,
  inputs,
  osConfig,
  ...
}:
with lib;
let
  cfg = config.modules.hyprland;
  palette = import ../../common/colors.nix;

  rgb = c: "rgb(${removePrefix "#" c})";
  argb = c: "0xFF${removePrefix "#" c}";
  unbrighten =
    coeff: c:
    let
      hex = removePrefix "#" c;
      channel =
        i:
        fixedWidthString 2 "0" (
          toHexString (builtins.floor (fromHexString (substring i 2 hex) / (1 + coeff) + 0.5))
        );
    in
    "0xFF${channel 0}${channel 2}${channel 4}";

  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkgs = inputs.hyprland.packages.${system};
  hyprlandPlugins = inputs.hyprland-plugins.packages.${system};

  binds = import ./binds.nix { inherit lib; };

  mkGrid =
    size:
    pkgs.runCommand "yorha-grid-${size}.png" { nativeBuildInputs = [ pkgs.imagemagick ]; } ''
      magick -size 12x12 xc:'${palette.raised}' -fill '${palette.surface}' \
        -draw 'rectangle 1,1 11,11' -write mpr:cell +delete \
        -size ${size} tile:mpr:cell $out
    '';

  gutter = 10;

  launcher = rec {
    fontSize = 15;
    rows = 3;
    height = 45 + rows * (2 * fontSize + 4) + (rows - 1) * 2;
  };

  lockDate = pkgs.writeShellScript "hyprlock-date" ''
    date=$(${pkgs.coreutils}/bin/date +'%A %d %B')
    echo "<span letter_spacing='6144'>''${date^^}</span>"
  '';

  wallpapers = {
    starfield-noise = toString ./wallpapers/starfield-noise.jpg;
    candle-circle-bonfire = toString ./wallpapers/candle-circle-bonfire.png;
    synthwave-city-sunset = toString ./wallpapers/synthwave-city-sunset.jpg;
    cyberpunk-skyline = toString ./wallpapers/cyberpunk-skyline.jpg;
    earthrise-duo = toString ./wallpapers/earthrise-duo.png;
    overwatch-yorha = toString ./wallpapers/overwatch-yorha.png;
    yorha-grid = toString (mkGrid "12x12");
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
          transform = mkOption {
            default = null;
            type = nullOr int;
          };
          cm = mkOption {
            default = null;
            type = nullOr str;
          };
          workspace = mkOption {
            default = null;
            type = nullOr str;
          };
        };
      });
    };

    wallpaper = mkOption {
      type = enum (attrNames wallpapers);
      default = "overwatch-yorha";
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
          fit_mode = if cfg.wallpaper == "yorha-grid" then "tile" else "fill";
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
        hyprbars
      ];

      configType = "lua";
      settings = {
        config = {
          general = {
            gaps_in = gutter / 2;
            gaps_out = gutter;
            border_size = 1;
            col = {
              active_border = palette.text;
              inactive_border = palette.surface;
              nogroup_border = palette.surface;
              nogroup_border_active = palette.text;
            };

            no_focus_fallback = true;
            resize_on_border = true;
            layout = "dwindle";
            allow_tearing = true;
          };

          decoration = {
            rounding = 0;
            blur.enabled = true;
            shadow = {
              enabled = true;
              sharp = true;
              range = 0;
              offset = [
                6
                6
              ];
              color = "rgba(00000066)";
            };
            active_opacity = 0.96;
            inactive_opacity = 0.96;
          };

          dwindle = {
            preserve_split = true;
          };

          binds = {
            movefocus_cycles_groupfirst = true;
          };

          group = {
            col = {
              border_active = palette.text;
              border_inactive = palette.surface;
            };
            groupbar = {
              text_color = palette.bg;
              text_color_inactive = palette.text;
              col = {
                active = palette.text;
                inactive = palette.surface;
              };
            };
          };

          render = {
            direct_scanout = 1;
          };

          misc = {
            background_color = palette.bg;
            disable_hyprland_logo = true;
            mouse_move_focuses_monitor = false;
          };

          plugin = {
            hyprbars = {
              bar_height = 20;
              bar_color = palette.surface;
              bar_text_size = 12;
              bar_text_weight = "medium";
              bar_text_font = "Noto Sans CJK JP";
              bar_text_align = "center";
              bar_part_of_window = true;
              bar_blur = true;
            };
          };

          xwayland = {
            use_nearest_neighbor = false;
          };

          input = {
            kb_layout = "us,ua";
            kb_options = "grp:win_space_toggle,caps:swapescape";
            follow_mouse = 2;
            float_switch_override_focus = 0;
            force_no_accel = true;
            sensitivity = 0;
          };
        };

        window_rule = [
          {
            _args = [
              {
                match = {
                  class = ".*";
                };
                float = true;
                size = [
                  "min(window_w, monitor_w * 0.65)"
                  "min(window_h, monitor_h * 0.65)"
                ];
              }
            ];
          }
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
                "hyprbars:bar_color" = rgb palette.text;
                "hyprbars:title_color" = rgb palette.bg;
              }
            ];
          }
          {
            _args = [
              {
                match = {
                  focus = false;
                };
                "hyprbars:title_color" = rgb palette.text;
              }
            ];
          }
          {
            _args = [
              {
                match = {
                  class = "com.mitchellh.ghostty";
                };
                opacity = "1.0 override";
              }
            ];
          }
          {
            _args = [
              {
                match = {
                  pin = true;
                };
                opacity = "0.8 override";
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
          _args = [ (filterAttrs (n: v: n != "workspace" && v != null) monitor) ];
        }) cfg.output;

        workspace_rule = builtins.map (monitor: {
          _args = [
            {
              inherit (monitor) workspace;
              monitor = monitor.output;
              default = true;
            }
          ];
        }) (filter (monitor: monitor.workspace != null) cfg.output);
      }
      // binds;
    };

    xdg.configFile."hypr/hyprtoolkit.conf".text = ''
      background = ${argb palette.bg}
      base = ${argb palette.bg}
      alternate_base = ${unbrighten 0.5 palette.bg}
      text = ${argb palette.text}
      bright_text = ${argb palette.bright}
      link_text = ${argb palette.blue}
      accent = ${argb palette.text}
      accent_secondary = ${argb palette.accentAlt}
      rounding_large = 0
      rounding_small = 0
      font_size = ${toString launcher.fontSize}
      font_family = Noto Sans CJK JP
      font_family_monospace = JetBrainsMono Nerd Font
    '';

    systemd.user.services.hyprlauncher.Unit.X-Restart-Triggers = [
      "${config.xdg.configFile."hypr/hyprtoolkit.conf".source}"
    ];

    services = {
      hypridle = {
        enable = true;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = ''hyprctl dispatch "hl.dsp.dpms('on')"'';
          };
        };
      };

      hyprlauncher = {
        enable = true;
        settings = {
          general = {
            grab_focus = true;
          };
          ui = {
            window_size = "440, ${toString launcher.height}";
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
            { color = rgb palette.surface; }
          ]
          ++ concatMap (
            o:
            let
              size = builtins.match "([0-9]+x[0-9]+)@.*" o.mode;
            in
            optional (size != null) {
              monitor = o.output;
              path = "${mkGrid (head size)}";
            }
          ) cfg.output;

          shape = [
            {
              size = "92%, 1";
              color = rgb palette.text;
              position = "0, -9%";
              halign = "center";
              valign = "top";
            }
          ];

          input-field = [
            {
              size = "420, 56";
              position = "0, -90";
              halign = "center";
              valign = "center";
              rounding = 0;
              outline_thickness = 2;
              outer_color = rgb palette.text;
              inner_color = rgb palette.bg;
              font_color = rgb palette.text;
              font_family = "Noto Sans CJK JP, JetBrainsMono Nerd Font";
              check_color = rgb palette.accentAlt;
              fail_color = rgb palette.red;
              placeholder_text = "<span foreground='##${removePrefix "#" palette.subtle}' letter_spacing='3072'>󰌾  ENTER ACCESS CODE</span>";
              fail_text = "<span letter_spacing='3072'>󰀦  $FAIL</span>";
              fade_on_empty = false;
            }
          ];

          label = [
            {
              text = "YoRHa";
              color = rgb palette.text;
              font_family = "Noto Sans CJK JP";
              font_size = 20;
              position = "4%, -5%";
              halign = "left";
              valign = "top";
            }
            {
              text = "UNIT ${toUpper (removePrefix "yorha" osConfig.networking.hostName)}";
              color = rgb palette.text;
              font_family = "Noto Sans CJK JP";
              font_size = 20;
              position = "-4%, -5%";
              halign = "right";
              valign = "top";
            }
            {
              text = "$TIME";
              color = rgb palette.text;
              font_family = "Noto Sans CJK JP Light";
              font_size = 120;
              position = "0, 110";
              halign = "center";
              valign = "center";
            }
            {
              text = "cmd[update:60000] ${lockDate}";
              color = rgb palette.text;
              font_family = "Noto Sans CJK JP";
              font_size = 18;
              position = "0, 0";
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
      package = pkgs.callPackage ./nier-cursors.nix { };
      name = "NieR-Cursors";
      size = 32;
      gtk.enable = true;
      hyprcursor.enable = true;
    };

    systemd.user.sessionVariables = {
      XCURSOR_THEME = config.home.pointerCursor.name;
      XCURSOR_SIZE = config.home.pointerCursor.size;
    };
  };
}
