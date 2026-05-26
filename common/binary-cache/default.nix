{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.modules.binary-cache;
in
{
  options.modules.binary-cache = {
    enable = mkEnableOption "Enable Attic binary cache substituter";
  };

  config = mkIf cfg.enable {
    nix.settings = {
      substituters = [
        "https://cache.andrewyazura.com/main?priority=30"
      ];

      trusted-public-keys = [
        "main:3p3SLFLPh7NUwZ/1940Ez5F3DX/LmMOfJeWSoMaSgxI="
      ];

      netrc-file = "/run/secrets/netrc";
    };
  };
}
