{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.theme;
in
{
  options.modules.theme = {
    enable = mkEnableOption "Enable global Catppuccin Mocha dark theme";
  };

  config = mkIf cfg.enable {
    # Set flavor and accent globally so catppuccin submodules inherit them.
    # Do NOT set catppuccin.enable — it would auto-theme every supported
    # program (btop, tmux, ghostty, etc.), overriding their existing configs.
    catppuccin = {
      flavor = "mocha";
      accent = "mauve";
    };

    catppuccin.kvantum.enable = true;
    catppuccin.cursors.enable = true;

    gtk = {
      enable = true;
      gtk3.extraConfig.gtk-application-prefer-dark-theme = 1;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = 1;
    };

    qt = {
      enable = true;
      platformTheme.name = "kvantum";
      style.name = "kvantum";
    };

    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    services.xsettingsd = {
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
