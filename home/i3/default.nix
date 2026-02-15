{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.i3;
in
{
  options.modules.i3 = {
    enable = mkEnableOption "Enable i3 configuration";
  };

  config = mkIf cfg.enable {
    home.file."Pictures/wallpapers/current.png".source = ../../common/wallpapers/nix-black-4k.png;

    xsession.windowManager.i3 =
      let
        palette = import ../../common/colors.nix;
      in
      {
        enable = true;
        package = pkgs.i3;
        config = rec {
          modifier = "Mod4";
          terminal = "ghostty";
          bars = [ ];
          window = {
            titlebar = false;
            border = 2;
          };

          colors = {
            focused = {
              border = palette.mauve;
              background = palette.mauve;
              text = palette.base;
              indicator = palette.mauve;
              childBorder = palette.mauve;
            };
            unfocused = {
              border = palette.base;
              background = palette.base;
              text = palette.text;
              indicator = palette.base;
              childBorder = palette.base;
            };
            urgent = {
              border = palette.red;
              background = palette.red;
              text = palette.base;
              indicator = palette.red;
              childBorder = palette.red;
            };
          };

          startup = [
            {
              command = "feh --bg-scale ~/Pictures/wallpapers/current.png";
              always = true;
            }
          ];

          keybindings =
            let
              super = "Mod4";
              alt = "Mod1";
              dmenuArgs = "-fn 'AdwaitaMono-12' -nb '${palette.crust}' -nf '${palette.text}' -sb '${palette.mauve}' -sf '${palette.base}'";
            in
            {
              "${alt}+space" = "exec dmenu_run ${dmenuArgs}";

              "${super}+Return" = "exec ${terminal}";
              "${super}+Escape" = "exec xsecurelock";
              "${alt}+q" = "kill";
              "${alt}+w" = "kill";

              "${super}+h" = "focus left";
              "${super}+j" = "focus down";
              "${super}+k" = "focus up";
              "${super}+l" = "focus right";

              "${super}+Shift+h" = "move left";
              "${super}+Shift+j" = "move down";
              "${super}+Shift+k" = "move up";
              "${super}+Shift+l" = "move right";

              "${super}+b" = "split h";
              "${super}+v" = "split v";
              "${super}+f" = "fullscreen toggle";

              "${super}+s" = "layout stacking";
              "${super}+w" = "layout tabbed";
              "${super}+e" = "layout toggle split";

              "${super}+Shift+n" = "floating toggle";
              "${super}+n" = "focus mode_toggle";

              "${super}+a" = "focus parent";

              "${super}+Shift+minus" = "move scratchpad";
              "${super}+minus" = "scratchpad show";

              "${super}+1" = "workspace number 1";
              "${super}+2" = "workspace number 2";
              "${super}+3" = "workspace number 3";
              "${super}+4" = "workspace number 4";
              "${super}+5" = "workspace number 5";
              "${super}+6" = "workspace number 6";
              "${super}+7" = "workspace number 7";
              "${super}+8" = "workspace number 8";
              "${super}+9" = "workspace number 9";
              "${super}+0" = "workspace number 10";

              "${super}+Shift+1" = "move container to workspace number 1";
              "${super}+Shift+2" = "move container to workspace number 2";
              "${super}+Shift+3" = "move container to workspace number 3";
              "${super}+Shift+4" = "move container to workspace number 4";
              "${super}+Shift+5" = "move container to workspace number 5";
              "${super}+Shift+6" = "move container to workspace number 6";
              "${super}+Shift+7" = "move container to workspace number 7";
              "${super}+Shift+8" = "move container to workspace number 8";
              "${super}+Shift+9" = "move container to workspace number 9";
              "${super}+Shift+0" = "move container to workspace number 10";

              "${super}+Shift+c" = "reload";
              "${super}+Shift+r" = "restart";
              "${super}+Shift+e" =
                "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

              "${super}+r" = "mode resize";

              "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
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
