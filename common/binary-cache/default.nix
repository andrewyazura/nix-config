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
in
{
  options.modules.binary-cache = {
    enable = mkEnableOption "Enable Attic binary cache substituter";

    push = {
      enable = mkEnableOption "Push locally built store paths to the Attic cache";

      endpoint = mkOption {
        type = types.str;
        default = "https://cache.andrewyazura.com/";
        description = "Attic server endpoint.";
      };

      cache = mkOption {
        type = types.str;
        default = "main";
        description = "Attic cache name to push to.";
      };

      netrcFile = mkOption {
        type = types.path;
        default = "/run/secrets/netrc";
        description = "netrc file holding the Attic token as its password field.";
      };

      package = mkOption {
        type = types.package;
        default = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}.attic-client;
        description = "Attic client. Taken from nixpkgs so the attic overlay does not apply.";
      };

      script = mkOption {
        type = types.path;
        internal = true;
        description = "Generated watch-store entry point.";
      };
    };
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

    modules.binary-cache.push.script = pkgs.writeShellScript "attic-watch-store" ''
      set -euo pipefail

      token=$(${pkgs.gnused}/bin/sed -n 's/.*password[[:space:]]\+\([^[:space:]]\+\).*/\1/p' ${cfg.push.netrcFile})
      if [ -z "$token" ]; then
        echo "no Attic token in ${cfg.push.netrcFile}" >&2
        exit 1
      fi

      dir="''${RUNTIME_DIRECTORY:-/var/run/attic-watch-store}"

      umask 077
      mkdir -p "$dir/attic"
      printf '%s' "$token" > "$dir/token"
      printf 'default-server = "%s"\n[servers.%s]\nendpoint = "%s"\ntoken-file = "%s"\n' \
        ${cfg.push.cache} ${cfg.push.cache} ${cfg.push.endpoint} "$dir/token" \
        > "$dir/attic/config.toml"

      export XDG_CONFIG_HOME="$dir"
      exec ${cfg.push.package}/bin/attic watch-store ${cfg.push.cache}
    '';
  };
}
