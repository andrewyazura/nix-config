{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.sway;
in {
  options.modules.sway = {
    enable = mkEnableOption "Enable sway configuration";
    output = mkOption {
      type = types.attrsOf (types.attrsOf types.str);
      default = { };
      description = ''
        Forward params to wayland.windowManager.sway.config.output
      '';
    };
    focus-output = mkOption {
      type = types.nullOr types.str;
      default = "";
      description = ''
        Define which output to focus by default
      '';
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      config = rec {
        left = "h";
        down = "j";
        up = "k";
        right = "l";

        modifier = "Mod4";
        terminal = "ghostty";
        menu =
          "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";

        keybindings = {
          "${modifier}+Return" = "exec ${terminal}";
          "${modifier}+Escape" = "exec waylock";
          "${modifier}+d" = "exec ${menu}";
          "${modifier}+q" = "kill";

          "${modifier}+${left}" = "focus left";
          "${modifier}+${down}" = "focus down";
          "${modifier}+${up}" = "focus up";
          "${modifier}+${right}" = "focus right";

          "${modifier}+Left" = "focus left";
          "${modifier}+Down" = "focus down";
          "${modifier}+Up" = "focus up";
          "${modifier}+Right" = "focus right";

          "${modifier}+Shift+${left}" = "move left";
          "${modifier}+Shift+${down}" = "move down";
          "${modifier}+Shift+${up}" = "move up";
          "${modifier}+Shift+${right}" = "move right";

          "${modifier}+Shift+Left" = "move left";
          "${modifier}+Shift+Down" = "move down";
          "${modifier}+Shift+Up" = "move up";
          "${modifier}+Shift+Right" = "move right";

          "${modifier}+b" = "splith";
          "${modifier}+v" = "splitv";
          "${modifier}+f" = "fullscreen toggle";
          "${modifier}+a" = "focus parent";

          "${modifier}+s" = "layout stacking";
          "${modifier}+w" = "layout tabbed";
          "${modifier}+e" = "layout toggle split";

          "${modifier}+Shift+n" = "floating toggle";
          "${modifier}+n" = "focus mode_toggle";

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

          "${modifier}+Shift+minus" = "move scratchpad";
          "${modifier}+minus" = "scratchpad show";

          "${modifier}+Shift+c" = "reload";
          "${modifier}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${modifier}+r" = "mode resize";

          "Print" = ''exec grim -g "$(slurp)" - | wl-copy'';
          "XF86AudioRaiseVolume" =
            "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" =
            "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

          "XF86AudioPlay" = "exec playerctl play-pause";
          "XF86AudioNext" = "exec playerctl next";
          "XF86AudioPrev" = "exec playerctl previous";
        };

        input = {
          "type:keyboard" = {
            xkb_layout = "us,ua";
            xkb_options = "grp:win_space_toggle,caps:swapescape";
          };

          "12771:4898:Wooting_Wooting_60HE+" = {
            xkb_options = "grp:win_space_toggle";
            # if settings reset:
            # swaymsg 'input "12771:4898:Wooting_Wooting_60HE+" xkb_options "grp:win_space_toggle"'
            # swaymsg 'input "12771:4898:Wooting_Wooting_60HE+" xkb_layout "us,ua"'
          };

          "12815:20580:SONIX_USB_DEVICE" = {
            xkb_options = "grp:win_space_toggle";
            # if settings reset:
            # swaymsg 'input "12815:20580:SONIX_USB_DEVICE" xkb_options "grp:win_space_toggle"'
            # swaymsg 'input "12815:20580:SONIX_USB_DEVICE" xkb_layout "us,ua"'
          };

          "type:pointer" = {
            accel_profile = "flat";
            pointer_accel = "0";
          };
        };

        output = cfg.output;

        focus = { followMouse = false; };
      };

      extraConfig = ''
        ${if cfg.focus-output != null then
          "focus output ${cfg.focus-output}"
        else
          ""}
      '';
    };
  };
}
