{ pkgs, config, ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = ",preferred,auto,1";

      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";

      env = [ "XCURSOR_SIZE,24" "HYPRCURSOR_SIZE,24" ];

      general = {
        gaps_in = 5;
        gaps_out = 20;
        border_size = 2;
        col = {
          active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          inactive_border = "rgba(595959aa)";
        };

        resize_on_border = false;
        allow_tearing = false;
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        col = { shadow = "rgba(1a1a1aee)"; };

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = false;
        preserve_split = true;
      };

      master = { new_is_master = true; };

      misc = {
        force_default_wallpaper = false;
        disable_hyprland_logo = false;
      };

      input = {
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = { natural_scroll = false; };
      };

      gestures = { workspace_swipe = true; };

      "$mainMod" = "SUPER";

      bind = [
        "$mainMod, return, exec, $terminal"
        "$mainMod, d, exec, $menu"
        "$mainMod, e, exec, $fileManager"
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

      ];
      "windowrulev2" = "suppressevent maximize, class:.*";
    };
  };
}
