{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.i3;
in {
  options.modules.i3 = { enable = mkEnableOption "Enable i3 configuration"; };

  config = mkIf cfg.enable {
    home.file."Pictures/wallpapers/current.png".source =
      ../../common/wallpapers/nix-black-4k.png;

    xsession.windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      config = rec {
        modifier = "Mod4";
        terminal = "ghostty";
        bars = [ ];
        window = {
          titlebar = false;
          border = 0;
        };

        startup = [{
          command = "feh --bg-scale ~/Pictures/wallpapers/current.png";
          always = true;
        }];

        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Escape" = "exec xsecurelock";
          "${modifier}+d" = "exec dmenu_run";
          "${modifier}+q" = "kill";

          "${modifier}+h" = "focus left";
          "${modifier}+j" = "focus down";
          "${modifier}+k" = "focus up";
          "${modifier}+l" = "focus right";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+j" = "move down";
          "${modifier}+Shift+k" = "move up";
          "${modifier}+Shift+l" = "move right";

          "${modifier}+b" = "split h";
          "${modifier}+v" = "split v";
          "${modifier}+f" = "fullscreen toggle";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+space" = "floating toggle";
          "${modifier}+space" = "focus mode_toggle";

          "${modifier}+a" = "focus parent";

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 10";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 2";
          "${modifier}+Shift+3" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+r" = "restart";
          "${modifier}+Shift+e" =
            "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

          "${modifier}+r" = "mode resize";

          "XF86AudioRaiseVolume" =
            "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" =
            "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
        };

        modes = {
          resize = {
            "h" = "resize shrink width 10 px or 10 ppt";
            "j" = "resize grow height 10 px or 10 ppt";
            "k" = "resize shrink height 10 px or 10 ppt";
            "l" = "resize grow width 10 px or 10 ppt";
            "Escape" = "mode default";
            "Return" = "mode default";
          };
        };

        focus = {
          followMouse = false;
          forceWrapping = false;
          wrapping = "no";
        };
      };
    };
  };
}
