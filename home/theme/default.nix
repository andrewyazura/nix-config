{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.theme;
  isLight = cfg.flavor == "latte";
in
{
  options.modules.theme = {
    enable = mkEnableOption "Enable global Catppuccin theme";

    flavor = mkOption {
      type = types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
      description = "Catppuccin flavor (latte = light, others = dark)";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      catppuccin = {
        enable = true;
        autoEnable = true;
        flavor = cfg.flavor;
        accent = "mauve";

        hyprland.enable = false; # causes "attempt to call a nil value (field 'source')"
        tmux.enable = false; # configured in tmux module
      };

      gtk = mkIf pkgs.stdenv.isLinux {
        enable = true;
        gtk3.extraConfig.gtk-application-prefer-dark-theme = if isLight then 0 else 1;
        gtk4.extraConfig.gtk-application-prefer-dark-theme = if isLight then 0 else 1;
      };

      qt = mkIf pkgs.stdenv.isLinux {
        enable = true;
        platformTheme.name = "kvantum";
        style.name = "kvantum";
      };

      dconf = mkIf pkgs.stdenv.isLinux {
        enable = true;
        settings."org/gnome/desktop/interface" = {
          color-scheme = if isLight then "prefer-light" else "prefer-dark";
        };
      };

      services.xsettingsd = mkIf pkgs.stdenv.isLinux {
        enable = true;
        settings = {
          "Net/ThemeName" = if isLight then "Adwaita" else "Adwaita-dark";
          "Xft/Antialias" = true;
          "Xft/Hinting" = true;
          "Xft/HintStyle" = "hintslight";
          "Xft/RGBA" = "rgb";
        };
      };
    })

    (mkIf (!cfg.enable) {
      catppuccin = {
        enable = false;
        autoEnable = false;
      };
    })
  ];
}
