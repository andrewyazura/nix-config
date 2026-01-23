{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.spotify;
in
{
  options.modules.spotify = {
    enable = mkEnableOption "Enable spotify configuration";
  };

  config = mkIf cfg.enable {
    programs.spotify-player = {
      enable = true;
      themes = import ./themes.nix;
      settings = {
        theme = "Catppuccin-mocha";
      };
    };
  };
}
