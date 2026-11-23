{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
{
  imports = [ ../../common/fonts ];

  config = mkIf config.modules.fonts.enable {
    fonts.packages = [ pkgs.noto-fonts-cjk-sans ];

    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel.rgba = "none";
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Noto Sans CJK JP" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
