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
in
{
  options.modules.theme = {
    enable = mkEnableOption "Enable the global dark theme";
  };

  config = mkIf cfg.enable {
    gtk = mkIf isLinux {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
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
        "Net/ThemeName" = "Adwaita-dark";
        "Xft/Antialias" = true;
        "Xft/Hinting" = true;
        "Xft/HintStyle" = "hintslight";
        "Xft/RGBA" = "rgb";
      };
    };
  };
}
