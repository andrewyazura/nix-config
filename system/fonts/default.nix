{
  lib,
  config,
  ...
}:
with lib;
{
  imports = [ ../../common/fonts ];

  config = mkIf config.modules.fonts.enable {
    fonts.fontconfig = {
      defaultFonts = {
        monospace = [ "JetBrainsMono Nerd Font" ];
        sansSerif = [ "Inter" ];
        serif = [ "Noto Serif" ];
      };
    };
  };
}
