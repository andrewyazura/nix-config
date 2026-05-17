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
        monospace = [ "SFMono Nerd Font" ];
        sansSerif = [ "SF Pro Display" ];
        serif = [ "New York" ];
      };
    };
  };
}
