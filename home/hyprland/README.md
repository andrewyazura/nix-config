# Hyprland

## Test a bind

Key presses from `wtype` do not trigger Hyprland binds. The focused client
gets them. Run the Lua body of the bind instead:

```
hyprctl eval "..."
```

Then read `hyprctl activewindow -j` and `hyprctl cursorpos`.

## Rebuilds and sessions

- A Hyprland version change needs a new session. Use `nixos-rebuild boot`,
  then reboot.
- Linger is off and tty1 is the only session. A Hyprland logout stops the
  user manager, and tmux stops about 10 s later.

## Monitors at 0x0 (yorha2b)

After both monitors power off and on, DP-1 and DP-2 can swap their DRM CRTCs.
Every modeset then fails, `hyprctl monitors` shows `0x0@60`, and the screens
show one frozen frame.

- Do not run `hyprctl reload` in this state. Hyprland aborts and restarts in
  safe mode, and all open apps close.
- In safe mode, click **Load config**. This restores the config, the plugins
  and the user services without a new login.
- To see the CRTC order, grep `hyprland.log` for `assigned to`, `taken by` and
  `Modesetting`. Only aquamarine lines reach this log.

If DP-1 then shows "out of range" at 500 Hz, set 120 Hz and power-cycle DP-1:

```
hyprctl eval "hl.monitor({ output = 'DP-1', mode = '2560x1440@120', position = '3840x360', bitdepth = 8 })"
```

The 500 Hz link does not train again before a reboot. A reload or a rebuild
applies 500 Hz again.

## Screen share does not open

The Vesktop or Chrome share dialog stops opening when
xdg-desktop-portal-hyprland loses its Wayland connection. The process does not
exit, so `Restart=` does not help.

Look for `wl_display#1: error 0: invalid object 7`, then
`Couldn't obtain a format from dma`:

```
journalctl --user -u xdg-desktop-portal-hyprland -b
```

Restart the portals:

```
systemctl --user restart xdg-desktop-portal-hyprland xdg-desktop-portal
```

Then quit the app from the tray and start it again. Chromium keeps a broken
capture state after a failed share.

The trigger: Chromium fails the DMA-BUF import on the RX 7900
(`EGL_BAD_MATCH`), the share falls back to SHM, and xdph then breaks.

## hyprlauncher input border

hyprtoolkit draws the border of a text box in two colors:

- Without keyboard focus, the border is `alternate_base`.
- With keyboard focus, the border is `alternate_base` brightened by 0.5.

`brighten(c)` multiplies each sRGB channel by `1 + c`, with no clamp. The
source is `src/palette/Color.cpp` in hyprtoolkit 0.6.0.

The launcher input box has focus while the launcher is open. To hide its
border, `unbrighten 0.5 palette.bg` in `default.nix` sets `alternate_base` to
bg divided by 1.5 per channel, rounded. For bg `#2b2924` the value is
`0xFF1D1B18`. A bg channel that is not a multiple of 3 has no exact result,
and the border is then half of one 8-bit step from bg.

The scroll bar track of the result list also uses `alternate_base`, with
alpha.

To debug a layer client, run its daemon with `WAYLAND_DEBUG=1` through
`setsid`. Read the `wl_keyboard` and `wl_pointer` enter events.

## hyprlauncher window height

`launcher.rows` and `launcher.fontSize` in `default.nix` give the height in
`window_size`. hyprlauncher 0.1.6 builds the window from these parts, in
`src/ui/UI.cpp` and `src/ui/ResultButton.cpp`:

- Fixed parts: 45 px. These are a 4 px margin at the top and at the bottom,
  the 28 px input box, a 4 px gap, the 1 px rule and a 4 px gap.
- Each result row: 2 × font size + 4 px. The row uses the font size in points
  as logical pixels.
- Between two rows: a 2 px gap.

With 3 rows at font size 15, the height is 45 + 3 × 34 + 2 × 2 = 151.

## hyprbars and blur

Keep window blur off while hyprbars draws the title band. With blur on, the
band of a floating window drops out where it overlaps a translucent tiled
window that repaints. The floating window's own shadow shows there instead.
`bar_blur` and `bar_part_of_window` do not change this. Only Ghostty is
translucent here, so blur has no other visible effect.

The defect follows repaints, so test with translucent windows and take many
pixel samples. One sample can miss it.

## Console colors and font (yorha2b)

`common/ansi.nix` holds the 16 terminal colors. The Ghostty palette and
`console.colors` in `system/hyprland/default.nix` both read it. On the virtual
console, slot 0 is the screen background and slot 7 the default text.

NixOS passes `console.colors` as the kernel parameters `vt.default_red`,
`vt.default_grn` and `vt.default_blu`. A rebuild writes them to the boot entry,
so new console colors show only after the next boot. `console.font` is
Terminus `ter-v32n` with `earlySetup`, so the initrd and the greeter use it.

## Login greeter (yorha2b)

greetd runs tuigreet with `--config` and a TOML file that
`system/hyprland/default.nix` builds. To check a new file, run:

```
tuigreet --config <file> --dump-config
tuigreet --config <file> --mock
```

`--mock` draws the greeter in the current terminal and fakes the login. The
0.11.1 help does not list it. greetd does not restart on a switch, so the
running session stays. A new greeter shows after the next logout or boot.

## Direct scanout

Set the instance signature again first. An old shell can point at a dead
instance, and `hyprctl` then writes "Couldn't connect" to stdout:

```
export HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl instances | head -1 | sed 's/instance //; s/://')
```

Focus the game and read `hyprctl monitors -j` every few seconds. A single read
just after focus can show blockers while the window settles. Scanout works
when `directScanoutTo` is not zero, and `directScanoutBlockedBy` and
`solitaryBlockedBy` are `null`.

A correct setup adds no `Modesetting DP-1` lines to
`$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log` across a
full alt-tab cycle.

CS2 "Fullscreen Windowed" reports `fullscreen: 2` and qualifies. It needs no
window rule.
