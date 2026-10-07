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
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
