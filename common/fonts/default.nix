{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts.enable = mkEnableOption "Enable fonts configuration";

  config = mkIf cfg.enable {
    fonts.packages = with pkgs; [
      fira-code
      inter
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      noto-fonts
    ];
  };
}
