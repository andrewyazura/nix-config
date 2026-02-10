{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.sway;
in
{
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
    wayland.windowManager.sway =
      let
        colors = import ../../common/colors.nix;
      in
      {
        enable = true;
        wrapperFeatures.gtk = true;

        config = rec {
          left = "h";
          down = "j";
          up = "k";
          right = "l";

          bars = [ ];
          window = {
            titlebar = false;
            border = 2;
          };

          colors = {
            focused = {
              border = colors.mauve;
              background = colors.mauve;
              text = colors.base;
              indicator = colors.mauve;
              childBorder = colors.mauve;
            };
            unfocused = {
              border = colors.base;
              background = colors.base;
              text = colors.text;
              indicator = colors.base;
              childBorder = colors.base;
            };
            urgent = {
              border = colors.red;
              background = colors.red;
              text = colors.base;
              indicator = colors.red;
              childBorder = colors.red;
            };
          };

          modifier = "Mod4";
          terminal = "ghostty";
          menu =
            let
              args = "-fn 'AdwaitaMono-12' -nb '${colors.crust}' -nf '${colors.text}' -sb '${colors.mauve}' -sf '${colors.base}'";
            in
            "${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu ${args} | ${pkgs.findutils}/bin/xargs swaymsg exec --";

          keybindings =
            let
              super = "Mod4";
              alt = "Mod1";
            in
            {
              "${alt}+Space" = "exec ${menu}";

              "${super}+Return" = "exec ${terminal}";
              "${super}+Escape" = "exec swaylock -c 000000";
              "${alt}+q" = "kill";
              "${alt}+w" = "kill";

              "${super}+${left}" = "focus left";
              "${super}+${down}" = "focus down";
              "${super}+${up}" = "focus up";
              "${super}+${right}" = "focus right";

              "${super}+Left" = "focus left";
              "${super}+Down" = "focus down";
              "${super}+Up" = "focus up";
              "${super}+Right" = "focus right";

              "${super}+Shift+${left}" = "move left";
              "${super}+Shift+${down}" = "move down";
              "${super}+Shift+${up}" = "move up";
              "${super}+Shift+${right}" = "move right";

              "${super}+Shift+Left" = "move left";
              "${super}+Shift+Down" = "move down";
              "${super}+Shift+Up" = "move up";
              "${super}+Shift+Right" = "move right";

              "${super}+b" = "splith";
              "${super}+v" = "splitv";
              "${super}+f" = "fullscreen toggle";
              "${super}+a" = "focus parent";

              "${super}+s" = "layout stacking";
              "${super}+w" = "layout tabbed";
              "${super}+e" = "layout toggle split";

              "${super}+Shift+n" = "floating toggle";
              "${super}+n" = "focus mode_toggle";

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

              "${super}+Shift+minus" = "move scratchpad";
              "${super}+minus" = "scratchpad show";

              "${super}+Shift+c" = "reload";
              "${super}+Shift+e" =
                "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

              "${super}+r" = "mode resize";

              "Print" = ''exec grim -g "$(slurp)" - | wl-copy'';

              "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

              "--locked XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
              "--locked XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              "--locked XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

              "XF86AudioPlay" = "exec playerctl play-pause";
              "XF86AudioNext" = "exec playerctl next";
              "XF86AudioPrev" = "exec playerctl previous";

              "--locked XF86AudioPlay" = "exec playerctl play-pause";
              "--locked XF86AudioNext" = "exec playerctl next";
              "--locked XF86AudioPrev" = "exec playerctl previous";
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

          focus = {
            followMouse = false;
          };
        };

        extraConfig = ''
          ${if cfg.focus-output != null then "focus output ${cfg.focus-output}" else ""}
        '';
      };

    programs.swaylock.enable = true;
  };
}
