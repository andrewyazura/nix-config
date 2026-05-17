{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.fonts;
in
{
  options.modules.fonts.enable = mkEnableOption "Enable fonts configuration";

  config = mkIf cfg.enable {
    fonts.packages =
      with pkgs;
      [
        fira-code
        nerd-fonts.fira-code
      ]
      ++ (with inputs.apple-fonts.packages.${stdenv.hostPlatform.system}; [
        sf-pro-nerd
        sf-mono-nerd
        ny-nerd
      ]);
  };
}
