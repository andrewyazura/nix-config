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

        serviceConfig = {
          User = "cs2";
          Group = "cs2";
          StateDirectory = stateDir;
          WorkingDirectory = installDir;
          Restart = "always";
          RestartSec = "10s";
          EnvironmentFile = v.environmentFiles;
        };

        preStart = ''
          ${pkgs.steamcmd}/bin/steamcmd \
            +force_install_dir ${installDir} \
            +login anonymous \
            +app_update 730 \
            +quit
        '';

        script = ''
          ${pkgs.steam-run}/bin/steam-run ${installDir}/game/bin/linuxsteamrt64/cs2 \
            -dedicated \
            -ip 0.0.0.0 \
            -port ${toString v.port} \
            -tickrate ${toString v.tickrate} \
            -maxplayers 10 \
            +map de_dust2 \
            +sv_setsteamaccount $GSLT_TOKEN
        '';
      }
    ) cfg.servers;
  };
}
