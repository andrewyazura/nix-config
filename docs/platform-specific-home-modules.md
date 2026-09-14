# Platform-specific home modules

Status: open. Recorded 2026-09-14. No action taken yet.

## Symptom

Commit `9bbb7cf` split `content-creation` out of the `desktop` profile. The
cause was a broken `yorhaA2` build. `kdenlive` and `obs-studio` are not
available on `aarch64-darwin`, and the `desktop` profile enabled both on every
host that used it.

The exact evaluation error at `9bbb7cf~1`:

```
error: Refusing to evaluate package 'kdenlive-26.08.0' ...
because it is not available on the requested hostPlatform
```

## Root cause

The `home/` tree is shared by NixOS hosts and the Darwin host. A module in
`home/` therefore runs on Linux and on macOS. Two modules in that tree contain
Linux-only content but declare no platform guard.

Other modules in the same tree do guard themselves:

- `home/theme/default.nix:10` binds `isLinux` and wraps `gtk`, `qt`, `dconf`
  and `services.xsettingsd`.
- `home/ghostty/default.nix:11` binds `isDarwin` and swaps the package.

So the repo has a convention. These two modules do not follow it.

## The two affected modules are not the same problem

### `home/video-editing/default.nix` — platform problem

The whole module is three lines of payload:

```nix
home.packages = [ pkgs.kdePackages.kdenlive ];
```

The intent is cross-platform. Only the package availability blocks it. A guard
on `pkgs.stdenv.hostPlatform.isLinux` fixes this module completely.

### `home/obs/default.nix` — host problem, not a platform problem

This module is larger and is pinned to one machine. It hardcodes the render
node of the `yorha2b` GPU:

```nix
vaapi_device = "/dev/dri/by-path/pci-0000:03:00.0-render";
```

It also selects `hevc_ffmpeg_vaapi_tex`, sets a 2560x1440 canvas, and disables
B-frames because of a VCN 4.0 limitation.

A platform guard is the wrong fix here. `isLinux` is true on `yorha9s`, which
has an Nvidia GPU and a different PCI path. Enabling `obs` there would write a
VAAPI profile that points at a device which does not exist, and it would fail
at runtime, not at evaluation. The module is silently host-specific today.

## Current state

`content-creation` is the workaround. It is enabled in exactly one place:

- `home/profiles/default.nix:51` declares the bundle.
- `users/andrew/home/yorha2b/default.nix:12` enables it.

The bundle works. It hides the real shape of the problem behind a profile axis
that is named after a use case, not after the constraint that created it.

## Options to consider later

1. **Guard `video-editing` on `isLinux`.** Smallest change. It removes the
   Darwin constraint from the profile layer.
2. **Move `obs` out of the profile layer.** It configures one GPU on one host.
   Either enable it directly in `users/andrew/home/yorha2b/`, or promote the
   render node to a module option so a second host can set its own.
3. **Then decide whether `content-creation` still earns a profile.** After
   options 1 and 2, the bundle may hold nothing that the `desktop` profile
   cannot hold.

Option 3 depends on 1 and 2. Do not start with it.

## Related

`plans/flake-check-all-hosts.md` adds the CI check that would have caught the
original break before the rebuild.
