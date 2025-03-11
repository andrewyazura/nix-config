{ lib, config, hyprland, hyprland-plugins, pkgs, ... }:
with lib;
let
  cfg = config.modules.hyprland;
  hypr = hyprland.packages.${pkgs.stdenv.hostPlatform.system};
  hypr-plugins = hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system};
in {
  options.modules.hyprland = {
    enable = mkEnableOption "Enable hyprland configuration";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;

      package = hypr.hyprland;
      portalPackage = hypr.xdg-desktop-portal-hyprland;

      plugins = with hypr-plugins; [ hyprbars hyprtrails ];

      settings = {
        "$mod" = "SUPER";
        "$terminal" = "ghostty";
        "$menu" = "tofi-drun --drun-launch=true";

        bind = [
          "$mod, T, exec, $terminal"
          "$mod, D, exec, $menu"
          "$mod, O, togglesplit"
          "$mod, M, fullscreen, 1"
          "$mod, escape, exec, hyprlock"

          "$mod, Q, killactive"
          "$mod SHIFT, Q, exit"

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          "ALT,Tab,cyclenext"
          "ALT,Tab,bringactivetotop"
        ] ++ builtins.concatLists (builtins.genList (i:
          let workspace = i + 1;
          in [
            "$mod, code:1${toString i}, workspace, ${toString workspace}"
            "$mod SHIFT, code:1${toString i}, movetoworkspace, ${
              toString workspace
            }"
          ]) 9);

        env = [
          "XCURSOR_SIZE,24"
          "HYPRCURSOR_SIZE,24"
          "SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/ssh-agent.socket"
        ];

        exec-once = [
          "waybar & hyprpaper & firefox"
          "eval $(ssh-agent) & ssh-add"
          "eval $(gnome-keyring-daemon --start)"
        ];

        general = {
          gaps_in = 5;
          gaps_out = 10;
          border_size = 2;
          col = {
            active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
            inactive_border = "rgba(595959aa)";
          };
          resize_on_border = false;
          allow_tearing = true;
          layout = "dwindle";
          no_focus_fallback = true;
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations = {
          enabled = true;
          bezier = [
            "easeOutQuint,0.23,1,0.32,1"
            "easeInOutCubic,0.65,0.05,0.36,1"
            "linear,0,0,1,1"
            "almostLinear,0.5,0.5,0.75,1.0"
            "quick,0.15,0,0.1,1"
          ];
          animation = [
            "global, 1, 10, default"
            "border, 1, 5.39, easeOutQuint"
            "windows, 1, 4.79, easeOutQuint"
            "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
            "windowsOut, 1, 1.49, linear, popin 87%"
            "fadeIn, 1, 1.73, almostLinear"
            "fadeOut, 1, 1.46, almostLinear"
            "fade, 1, 3.03, quick"
            "layers, 1, 3.81, easeOutQuint"
            "layersIn, 1, 4, easeOutQuint, fade"
            "layersOut, 1, 1.5, linear, fade"
            "fadeLayersIn, 1, 1.79, almostLinear"
            "fadeLayersOut, 1, 1.39, almostLinear"
            "workspaces, 1, 1.94, almostLinear, fade"
            "workspacesIn, 1, 1.21, almostLinear, fade"
            "workspacesOut, 1, 1.94, almostLinear, fade"
          ];
        };

        misc = {
          disable_hyprland_logo = true;
          animate_manual_resizes = true;
          key_press_enables_dpms = true;
          mouse_move_enables_dpms = true;
        };

        cursor = {
          sync_gsettings_theme = true;
          enable_hyprcursor = false;
        };

        input = {
          kb_layout = "us";
          sensitivity = 0;
          follow_mouse = 2;
        };

        # ensure tearing in cs2
        windowrulev2 = [
          "suppressevent maximize, class:.*"
          "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
          "immediate, class:^(cs2)$"
        ];
      };

      extraConfig = ''
        # Start resize submap on mod + return
        bind = $mod, return, submap, resize
        submap = resize

        binde = , h, movewindow, l
        binde = , l, movewindow, r
        binde = , k, movewindow, u
        binde = , j, movewindow, d

        binde = SHIFT, h, resizeactive, -10 0
        binde = SHIFT, l, resizeactive, 10 0
        binde = SHIFT, k, resizeactive, 0 -10
        binde = SHIFT, j, resizeactive, 0 10

        bind = , escape, submap, reset
        bind = , return, submap, reset
        submap = reset
      '';
    };
  };
}
