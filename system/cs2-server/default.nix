{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.cs2-server;
in
{
  options.modules.cs2-server = with types; {
    enable = mkEnableOption "Enable bare-metal CS2 server configuration";

    servers = mkOption {
      default = { };
      type = attrsOf (submodule {
        options = {
          port = mkOption {
            type = int;
            default = 27015;
          };

          tvPort = mkOption {
            type = int;
            default = 27020;
          };

          tickrate = mkOption {
            type = int;
            default = 64;
          };

          map = mkOption {
            type = str;
            default = "de_dust2";
          };

          admins = mkOption {
            type = attrsOf (submodule {
              options = {
                identity = mkOption { type = str; };
                flags = mkOption {
                  type = listOf str;
                  default = [ "@css/root" ];
                };
              };
            });
            default = { };
          };

          environmentFiles = mkOption {
            type = listOf str;
            default = [ ];
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    users.users.cs2 = {
      isSystemUser = true;
      group = "cs2";
    };
    users.groups.cs2 = { };

    networking.firewall.allowedTCPPorts = mapAttrsToList (name: v: v.port) cfg.servers;
    networking.firewall.allowedUDPPorts = concatLists (
      mapAttrsToList (name: v: [
        v.port
        v.tvPort
      ]) cfg.servers
    );

    systemd.services = mapAttrs' (
      name: v:
      let
        stateDir = "cs2/${name}";
        installDir = "/var/lib/${stateDir}";
      in
      nameValuePair "cs2-${name}" {
        description = "CS2 Dedicated Server - ${name}";
        wantedBy = [ "multi-user.target" ];
        after = [
          "network.target"
          "sops-nix.service"
        ];

        environment = {
          HOME = installDir;
        };

        serviceConfig = {
          User = "cs2";
          Group = "cs2";
          StateDirectory = stateDir;
          WorkingDirectory = installDir;
          Restart = "always";
          RestartSec = "10s";
          EnvironmentFile = v.environmentFiles;
          TimeoutStartSec = "15min";
        };

        preStart = ''
          ${pkgs.steamcmd}/bin/steamcmd \
            +force_install_dir ${installDir} \
            +login anonymous \
            +app_update 730 \
            +quit

          mkdir -p ${installDir}/.steam/sdk64
          STEAMCLIENT=$(${pkgs.findutils}/bin/find ${installDir} -type f -name "steamclient.so" | ${pkgs.gnugrep}/bin/grep "linux64" | ${pkgs.coreutils}/bin/head -n 1)

          if [ -n "$STEAMCLIENT" ]; then
            ln -sf "$STEAMCLIENT" ${installDir}/.steam/sdk64/steamclient.so
            echo "Successfully linked steamclient.so from $STEAMCLIENT"
          else
            echo "CRITICAL ERROR: Could not find steamclient.so anywhere in ${installDir}"
          fi

          # Install plugins
          mkdir -p ${installDir}/game/csgo/addons ${installDir}/game/csgo/cfg
          chmod -R +w ${installDir}/game/csgo/addons ${installDir}/game/csgo/cfg 2>/dev/null || true

          cp -rfT --no-preserve=mode ${
            pkgs.callPackage ./plugins.nix { }
          }/addons ${installDir}/game/csgo/addons

          if [ -d ${pkgs.callPackage ./plugins.nix { }}/cfg ]; then
            cp -rnT --no-preserve=mode ${pkgs.callPackage ./plugins.nix { }}/cfg ${installDir}/game/csgo/cfg
          fi

          chmod -R +w ${installDir}/game/csgo/addons ${installDir}/game/csgo/cfg

          # Inject Metamod into gameinfo.gi
          GAMEINFO="${installDir}/game/csgo/gameinfo.gi"
          if [ -f "$GAMEINFO" ]; then
            if ! ${pkgs.gnugrep}/bin/grep -q "csgo/addons/metamod" "$GAMEINFO"; then
              ${pkgs.gawk}/bin/awk '/SearchPaths/ {print; getline; print; print "\t\t\tGame\tcsgo/addons/metamod"; next} 1' "$GAMEINFO" > "$GAMEINFO.tmp"
              mv "$GAMEINFO.tmp" "$GAMEINFO"
            fi
          fi

          # Setup Admins
          ${
            if v.admins != { } then
              ''
                  mkdir -p ${installDir}/game/csgo/addons/counterstrikesharp/configs
                  cat <<'EOF' > ${installDir}/game/csgo/addons/counterstrikesharp/configs/admins.json
                ${builtins.toJSON v.admins}
                EOF
              ''
            else
              ""
          }
        '';

        script = ''
          ${pkgs.steam-run}/bin/steam-run bash -c '
            export LD_LIBRARY_PATH=${installDir}/game/bin/linuxsteamrt64:$LD_LIBRARY_PATH
            
            exec ${installDir}/game/bin/linuxsteamrt64/cs2 \
              -dedicated \
              -ip 0.0.0.0 \
              -port ${toString v.port} \
              -tickrate ${toString v.tickrate} \
              -maxplayers 10 \
              -authkey $STEAM_WEB_API_KEY \
              +sv_setsteamaccount $GSLT_TOKEN \
              +map ${v.map}
          '
        '';
      }
    ) cfg.servers;
  };
}
