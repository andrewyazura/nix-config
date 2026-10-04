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

## hyprlauncher override

`default.nix` overrides hyprtoolkit to 0.6.0 for hyprlauncher only.
hyprtoolkit 0.5.x drops keys when the pointer is not over the window, so the
launcher ignored keys after a mouse click. Remove the override when nixpkgs
has hyprtoolkit 0.6.0 or later. On 2026-10-01, nixpkgs has 0.5.4.

To debug a layer client, run its daemon with `WAYLAND_DEBUG=1` through
`setsid`. Read the `wl_keyboard` and `wl_pointer` enter events.

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
