{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.theme;
  isLinux = pkgs.stdenv.hostPlatform.isLinux;
  colors = import ../../common/colors.nix;

  surfaces = {
    window = colors.bg;
    view = colors.bg;
    headerbar = colors.surface;
    sidebar = colors.surface;
    card = colors.surface;
    dialog = colors.surface;
    popover = colors.surface;
  };

  gtkCss =
    concatStrings (
      mapAttrsToList (name: bg: ''
        @define-color ${name}_bg_color ${bg};
        @define-color ${name}_fg_color ${colors.text};
      '') surfaces
    )
    + ''
      @define-color sidebar_backdrop_color ${colors.bg};
      @define-color accent_bg_color ${colors.text};
      @define-color accent_fg_color ${colors.bg};
    '';
in
{
  options.modules.theme = {
    enable = mkEnableOption "Enable the global dark theme";
  };

  config = mkIf cfg.enable {
    gtk = mkIf isLinux {
      enable = true;
      font = {
        name = "Noto Sans CJK JP";
        package = pkgs.noto-fonts-cjk-sans;
        size = 11;
      };
      theme = {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk3.extraCss = gtkCss;
      gtk4.theme = null;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraCss = gtkCss;
    };

    qt = mkIf isLinux {
      enable = true;
      platformTheme.name = "adwaita";
      style.name = "adwaita-dark";
    };

    dconf = mkIf isLinux {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    services.xsettingsd = mkIf isLinux {
      enable = true;
      settings = {
        "Net/ThemeName" = "adw-gtk3-dark";
        "Xft/Antialias" = true;
        "Xft/Hinting" = true;
        "Xft/HintStyle" = "hintslight";
        "Xft/RGBA" = "rgb";
      };
    };
  };
}
