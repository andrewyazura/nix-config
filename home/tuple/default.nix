{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.tuple;
  version = "2026_11_02.0";
  tuple = pkgs.runCommand "tuple-${version}" { } ''
    install -Dm755 ${
      pkgs.fetchurl {
        url = "https://tuple-client-releases.s3.amazonaws.com/linux/v${version}/x86_64/tuple";
        hash = "sha256-Zr1F2k3d5Uk0p8+UMjzHV3PkmT0khrB7m3cpy9SMOxQ=";
      }
    } $out/bin/tuple
  '';
in
{
  options.modules.tuple = {
    enable = mkEnableOption "Enable Tuple pair programming client";
  };

  config = mkIf cfg.enable {
    home.packages = [ tuple ];
  };
}
