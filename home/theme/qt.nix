{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.theme;
  colors = import ../../common/colors.nix;

  roles = [
    "WindowText"
    "Button"
    "Light"
    "Midlight"
    "Dark"
    "Mid"
    "Text"
    "BrightText"
    "ButtonText"
    "Base"
    "Window"
    "Shadow"
    "Highlight"
    "HighlightedText"
    "Link"
    "LinkVisited"
    "AlternateBase"
    "NoRole"
    "ToolTipBase"
    "ToolTipText"
    "PlaceholderText"
    "Accent"
  ];

  active = with colors; {
    Window = bg;
    WindowText = text;
    Base = bg;
    AlternateBase = surface;
    Text = text;
    Button = surface;
    ButtonText = text;
    BrightText = bright;
    Light = overlay;
    Midlight = raised;
    Mid = bg;
    Dark = bg;
    Shadow = bg;
    Highlight = text;
    HighlightedText = bg;
    Accent = text;
    Link = blue;
    LinkVisited = pink;
    NoRole = bg;
    ToolTipBase = bg;
    ToolTipText = text;
    PlaceholderText = subtle;
  };

  disabled =
    active
    // (with colors; {
      WindowText = muted;
      Text = muted;
      ButtonText = muted;
      PlaceholderText = overlay;
      BrightText = subtle;
      Link = muted;
      LinkVisited = muted;
      Highlight = muted;
    });

  row = group: concatMapStringsSep ", " (role: group.${role}) roles;

  scheme = ''
    [ColorScheme]
    active_colors=${row active}
    inactive_colors=${row active}
    disabled_colors=${row disabled}
  '';

  check = pkgs.writeText "check.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12"><path d="M2.5 6.5 5 9 9.5 3" fill="none" stroke="${colors.bg}" stroke-width="2"/></svg>
  '';

  dot = pkgs.writeText "dot.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" viewBox="0 0 12 12"><circle cx="6" cy="6" r="2.5" fill="${colors.bg}"/></svg>
  '';

  indicators = pkgs.writeText "indicators.qss" (
    with colors;
    ''
      QCheckBox::indicator, QAbstractItemView::indicator, QGroupBox::indicator, QRadioButton::indicator {
          width: 12px;
          height: 12px;
          border: 1px solid ${text};
          background: ${bg};
      }
      QRadioButton::indicator {
          border-radius: 7px;
      }
      QCheckBox::indicator:checked, QAbstractItemView::indicator:checked, QGroupBox::indicator:checked {
          background: ${text};
          image: url(${check});
      }
      QRadioButton::indicator:checked {
          background: ${text};
          image: url(${dot});
      }
      QCheckBox::indicator:indeterminate, QAbstractItemView::indicator:indeterminate {
          background: ${muted};
      }
      QCheckBox::indicator:disabled, QAbstractItemView::indicator:disabled, QGroupBox::indicator:disabled, QRadioButton::indicator:disabled {
          border-color: ${muted};
      }
      QCheckBox::indicator:checked:disabled, QAbstractItemView::indicator:checked:disabled, QGroupBox::indicator:checked:disabled, QRadioButton::indicator:checked:disabled {
          background: ${muted};
      }
    ''
  );

  qtct = name: {
    Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/${name}/colors/yorha.conf";
    };
    Interface = {
      stylesheets = "${indicators}";
    };
    Fonts = {
      general = ''"Noto Sans CJK JP,11"'';
      fixed = ''"JetBrainsMono Nerd Font,11"'';
    };
  };
in
{
  config = mkIf (cfg.enable && pkgs.stdenv.hostPlatform.isLinux) {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      qt5ctSettings = qtct "qt5ct";
      qt6ctSettings = qtct "qt6ct";
    };

    xdg.configFile = genAttrs [ "qt5ct/colors/yorha.conf" "qt6ct/colors/yorha.conf" ] (_: {
      text = scheme;
    });
  };
}
