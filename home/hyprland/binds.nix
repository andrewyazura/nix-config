{ lib }:
let
  mkLua = lib.generators.mkLuaInline;
  mkBind = bind: command: {
    _args = [
      bind
      (mkLua command)
    ];
  };
  mkLockedBind = bind: command: {
    _args = [
      bind
      (mkLua command)
      { locked = true; }
    ];
  };

  workspaces = [
    {
      key = "1";
      ws = "1";
    }
    {
      key = "2";
      ws = "2";
    }
    {
      key = "3";
      ws = "3";
    }
    {
      key = "4";
      ws = "4";
    }
    {
      key = "5";
      ws = "5";
    }
    {
      key = "6";
      ws = "6";
    }
    {
      key = "7";
      ws = "7";
    }
    {
      key = "8";
      ws = "8";
    }
    {
      key = "9";
      ws = "9";
    }
    {
      key = "0";
      ws = "10";
    }
  ];
in
{
  bind = [
    (mkBind "SUPER + RETURN" "hl.dsp.exec_cmd('ghostty')")
    (mkBind "ALT + SPACE" "hl.dsp.exec_cmd('hyprlauncher')")
    (mkBind "SUPER + ESCAPE" "hl.dsp.exec_cmd('hyprlock')")

    (mkBind "ALT + Q" "hl.dsp.window.close()")
    (mkBind "ALT + W" "hl.dsp.window.close()")

    (mkBind "SUPER + H" "hl.dsp.movefocus('l')")
    (mkBind "SUPER + J" "hl.dsp.movefocus('d')")
    (mkBind "SUPER + K" "hl.dsp.movefocus('u')")
    (mkBind "SUPER + L" "hl.dsp.movefocus('r')")

    (mkBind "SUPER SHIFT + H" "hl.dsp.movewindow('l')")
    (mkBind "SUPER SHIFT + J" "hl.dsp.movewindow('d')")
    (mkBind "SUPER SHIFT + K" "hl.dsp.movewindow('u')")
    (mkBind "SUPER SHIFT + L" "hl.dsp.movewindow('r')")

    (mkBind "SUPER + E" "hl.dsp.togglesplit()")
    (mkBind "SUPER + F" "hl.dsp.fullscreen('0')")
    (mkBind "SUPER SHIFT + N" "hl.dsp.togglefloating()")

    (mkBind "SUPER + MINUS" "hl.dsp.togglespecialworkspace()")
    (mkBind "SUPER SHIFT + MINUS" "hl.dsp.movetoworkspace('special')")

    (mkBind "SUPER + R" "hl.dsp.submap('resize')")

    (mkBind "PRINT" ''hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy')'')

    # Audio / Media (Locked binds allowing use while screen is locked)
    (mkLockedBind "XF86AudioRaiseVolume" "hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+')")
    (mkLockedBind "XF86AudioLowerVolume" "hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-')")
    (mkLockedBind "XF86AudioMute" "hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')")

    (mkLockedBind "XF86AudioPlay" "hl.dsp.exec_cmd('playerctl play-pause')")
    (mkLockedBind "XF86AudioNext" "hl.dsp.exec_cmd('playerctl next')")
    (mkLockedBind "XF86AudioPrev" "hl.dsp.exec_cmd('playerctl previous')")

  ]
  ++ (map (x: mkBind "SUPER + ${x.key}" "hl.dsp.workspace('${x.ws}')") workspaces)
  ++ (map (x: mkBind "SUPER SHIFT + ${x.key}" "hl.dsp.movetoworkspace('${x.ws}')") workspaces);

  define_submap = {
    _args = [
      "resize"
      (mkLua ''
        function()
          hl.bind('h', hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
          hl.bind('j', hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
          hl.bind('k', hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
          hl.bind('l', hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
          hl.bind('escape', hl.dsp.submap('reset'))
          hl.bind('return', hl.dsp.submap('reset'))
        end
      '')
    ];
  };
}
