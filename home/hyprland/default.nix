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
  system = pkgs.stdenv.hostPlatform.system;
  hyprlandPkgs = inputs.hyprland.packages.${system};
  hyprlandPlugins = inputs.hyprland-plugins.packages.${system};

  binds = import ./binds.nix { inherit lib; };
  mkLua = lib.generators.mkLuaInline;
in
{
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      package = hyprlandPkgs.hyprland;
      portalPackage = hyprlandPkgs.xdg-desktop-portal-hyprland;

      plugins = with hyprlandPlugins; [
        csgo-vulkan-fix
        hyprbars
      ];

      configType = "lua";
      settings = {
        config = {
          general = {
            gaps_in = 5;
            gaps_out = 20;
            border_size = 2;
            col = {
              active_border = mkLua "0xff";
              inactive_border = mkLua "0xff";
            };

            no_focus_fallback = true;
            resize_on_border = true;
          };

          decoration = {
            rounding = 10;
            rounding_power = 4.0;
            blur.enabled = true;
            shadow.enabled = true;
            glow.enabled = true;
          };

          input = {
            kb_layout = "us,ua";
            kb_options = "grp:win_space_toggle,caps:swapescape";
            follow_mouse = 0;
            force_no_accel = true;
            sensitivity = 0;
          };
        };

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
      }
      // binds;
    };

    services.hyprlauncher = {
      enable = true;
      settings = {
        general = {
          grab_focus = true;
        };
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = false;
          ignore_empty_input = true;
        };
      };
    };
  };
}
