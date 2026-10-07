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

  qtct = name: {
    Appearance = {
      style = "Fusion";
      custom_palette = true;
      color_scheme_path = "${config.xdg.configHome}/${name}/colors/yorha.conf";
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
