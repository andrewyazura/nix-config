{ pkgs, inputs, ... }:
{
  wayland.windowManager.hyprland = {
    enable = true;
    plugins =
      with inputs.hyprland-plugins.packages."${pkgs.system}";
      [
        hyprbars
        hyprexpo
        hyprtrails
        hyprwinwrap
        borders-plus-plus
      ]
      ++ [ inputs.hy3.packages."${pkgs.system}".hy3 ];
  };

  home.file.".config/hypr" = {
    source = ./hypr;
    recursive = true;
  };

  systemd.user.sessionVariables = {
    "NIXOS_OZONE_WL" = "1";
    "MOZ_ENABLE_WAYLAND" = "1";
    "MOZ_WEBRENDER" = "1";

    "LIBVA_DRIVER_NAME" = "nvidia";
    "XDG_SESSION_TYPE" = "wayland";
    "GBM_BACKEND" = "nvidia-drm";
    "__GLX_VENDOR_LIBRARY_NAME" = "nvidia";
    "WLR_NO_HARDWARE_CURSORS" = "1";
    "WLR_EGL_NO_MODIFIRES" = "1";
  };
}
