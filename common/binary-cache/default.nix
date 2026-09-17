{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.binary-cache;

  attic = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.attic-client;

  attic-push = pkgs.writeShellScriptBin "attic-push" ''
    set -euo pipefail

    token=$(${pkgs.gnused}/bin/sed -n 's/.*password[[:space:]]\+\([^[:space:]]\+\).*/\1/p' /run/secrets/netrc)
    if [ -z "$token" ]; then
      echo "no Attic token in /run/secrets/netrc" >&2
      exit 1
    fi

    dir=$(mktemp -d)
    trap 'rm -rf "$dir"' EXIT

    umask 077
    mkdir -p "$dir/attic"
    printf '%s' "$token" > "$dir/token"
    printf 'default-server = "main"\n[servers.main]\nendpoint = "https://cache.andrewyazura.com/"\ntoken-file = "%s"\n' \
      "$dir/token" > "$dir/attic/config.toml"

    XDG_CONFIG_HOME="$dir" ${attic}/bin/attic push main "$@"
  '';
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

    environment.systemPackages = [ attic-push ];
  };
}
