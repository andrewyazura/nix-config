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
        "main:T8v5SdwjNhvJowlHJFFNB1O9PbXyLrZ+vRKe7OWGCa8="
      ];

      netrc-file = "/run/secrets/netrc";
    };
  };
}
