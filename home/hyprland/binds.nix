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
    (mkBind "CTRL + ALT + Q" "hl.dsp.exec_cmd('hyprlock')")

    (mkBind "ALT + Q" "hl.dsp.window.close()")

    (mkBind "SUPER + H" "function() hl.dispatch(hl.dsp.focus({ direction = 'left' })); hl.dispatch(hl.dsp.window.bring_to_top()) end")
    (mkBind "SUPER + J" "function() hl.dispatch(hl.dsp.focus({ direction = 'down' })); hl.dispatch(hl.dsp.window.bring_to_top()) end")
    (mkBind "SUPER + K" "function() hl.dispatch(hl.dsp.focus({ direction = 'up' })); hl.dispatch(hl.dsp.window.bring_to_top()) end")
    (mkBind "SUPER + L" "function() hl.dispatch(hl.dsp.focus({ direction = 'right' })); hl.dispatch(hl.dsp.window.bring_to_top()) end")

    (mkBind "SUPER + SHIFT + H" "hl.dsp.window.move({ direction = 'left', group_aware = true })")
    (mkBind "SUPER + SHIFT + J" "hl.dsp.window.move({ direction = 'down', group_aware = true })")
    (mkBind "SUPER + SHIFT + K" "hl.dsp.window.move({ direction = 'up', group_aware = true })")
    (mkBind "SUPER + SHIFT + L" "hl.dsp.window.move({ direction = 'right', group_aware = true })")

    (mkBind "SUPER + E" "hl.dsp.layout('togglesplit')")
    (mkBind "SUPER + W" "hl.dsp.group.toggle()")
    (mkBind "SUPER + B" "hl.dsp.layout('preselect r')")
    (mkBind "SUPER + V" "hl.dsp.layout('preselect d')")
    (mkBind "SUPER + F" "hl.dsp.window.fullscreen()")
    (mkBind "SUPER + N" "function() hl.dispatch(hl.dsp.window.cycle_next({ floating = not hl.get_active_window().floating })); hl.dispatch(hl.dsp.window.bring_to_top()) end")
    (mkBind "SUPER + SHIFT + N" "hl.dsp.window.float({ action = 'toggle' })")
    (mkBind "SUPER + P" "hl.dsp.window.pin()")

    (mkBind "SUPER + MINUS" "hl.dsp.workspace.toggle_special('')")
    (mkBind "SUPER + SHIFT + MINUS" "hl.dsp.window.move({ workspace = 'special' })")

    (mkBind "SUPER + R" "hl.dsp.submap('resize')")

    (mkBind "ALT + SHIFT + 3" "hl.dsp.exec_cmd('grim - | wl-copy')")
    (mkBind "ALT + SHIFT + 4" ''hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy')'')

    (mkBind "SUPER + D" "hl.dsp.exec_cmd('dictate')")
    (mkBind "SUPER + SHIFT + D" "hl.dsp.exec_cmd('dictate cancel')")

    (mkLockedBind "XF86AudioRaiseVolume" "hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+')")
    (mkLockedBind "XF86AudioLowerVolume" "hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-')")
    (mkLockedBind "XF86AudioMute" "hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')")

    (mkLockedBind "XF86AudioPlay" "hl.dsp.exec_cmd('playerctl play-pause')")
    (mkLockedBind "XF86AudioNext" "hl.dsp.exec_cmd('playerctl next')")
    (mkLockedBind "XF86AudioPrev" "hl.dsp.exec_cmd('playerctl previous')")
  ]
  ++ (map (x: mkBind "SUPER + ${x.key}" "hl.dsp.focus({ workspace = '${x.ws}' })") workspaces)
  ++ (map (
    x: mkBind "SUPER + SHIFT + ${x.key}" "hl.dsp.window.move({ workspace = '${x.ws}' })"
  ) workspaces);

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
