{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.minecraft-server;
  enabledBackupServers = filterAttrs (name: server: server.backup.enable) cfg.servers;
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.modules.minecraft-server = with types; {
    enable = mkEnableOption "Enable Minecraft server configuration";

    servers = mkOption {
      type = attrsOf (submodule ({
        options = {
          jvmOpts = mkOption {
            type = nullOr str;
            default = null;
            description = "JVM options for the server";
          };

          serverProperties = mkOption {
            type = attrsOf (oneOf [
              bool
              int
              str
            ]);
            default = { };
            description = "Properties for the server.properties file";
          };

          backup = {
            enable = mkOption {
              type = bool;
              default = false;
              description = "Enable scheduled rclone backups for this Minecraft server.";
            };

            remote = mkOption {
              type = str;
              example = "drive:backups/minecraft";
              description = "rclone remote destination (e.g., 'drive:backups/minecraft').";
            };

            rcloneConfigFile = mkOption {
              type = nullOr path;
              default = null;
              description = "Path to the read-only decrypted sops-nix secret configuration file.";
            };

            environmentFile = mkOption {
              type = nullOr path;
              default = null;
              description = "Path to sops-decrypted or env file containing rclone secrets.";
            };

            calendar = mkOption {
              type = str;
              default = "04:00";
              description = "Systemd timer calendar expression (when to run the backup).";
            };

            retentionDays = mkOption {
              type = int;
              default = 1;
              description = "Number of days to keep local and remote backups.";
            };
          };
        };
      }));

      default = { };
      description = "Per-server configuration overrides";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = false;

      servers =
        let
          players = import ./players.nix;
          mods = import ./mods.nix { inherit pkgs; };

          serverTemplate = {
            enable = true;
            enableReload = true;
            package = pkgs.fabricServers.fabric-26_1_2;

            symlinks.mods = pkgs.linkFarmFromDrvs "mods" (attrValues mods);

            operators = players.toOperators players.offline;
            whitelist = players.toWhitelist players.offline;

            serverProperties = {
              enforce-secure-profile = false;
              gamemode = "survival";
              max-players = length players.list;
              online-mode = false;
              spawn-protection = 0;
              white-list = true;
            };
          };

          customServers = {
            bombas = {
              serverProperties = {
                motd = "\\u00A7a\\u00A7l8 let dambili\\u00A7r\\u00A7r";
              };

              symlinks = {
                "server-icon.png" = builtins.path {
                  path = ./bombas-server-icon.png;
                  name = "bombas-server-icon.png";
                };
              };
            };
          };

        in
        mapAttrs (
          name: value:
          recursiveUpdate (recursiveUpdate serverTemplate value) (
            builtins.removeAttrs (cfg.servers.${name} or { }) [ "backup" ]
          )
        ) customServers;
    };

    networking.firewall =
      let
        allowedIps = [
          # neoprotect
          "51.195.127.71/32"
          "51.195.127.72/32"
          "51.195.127.90/32"
          "51.195.127.91/32"
          "15.204.187.208/32"
          "15.204.187.209/32"
          "15.204.130.224/32"
          "15.204.131.21/32"
          "54.36.238.155/32"
          "54.36.238.165/32"
          "54.36.238.136/32"
          "54.36.238.139/32"
          "54.36.238.170/32"
          "54.36.238.180/32"
          "82.22.5.0/24"
        ];

        allPorts = mapAttrsToList (
          name: server: toString (server.serverProperties.server-port or 25565)
        ) cfg.servers;

        uniquePorts = unique allPorts;
      in
      {
        extraCommands = concatMapStrings (
          port:
          concatMapStrings (ip: ''
            iptables -A INPUT -p tcp -s ${ip} --dport ${port} -j ACCEPT
          '') allowedIps
        ) uniquePorts;

        extraStopCommands = concatMapStrings (port: ''
          iptables -D INPUT -p tcp --dport ${port} -j ACCEPT || true
        '') uniquePorts;
      };

    systemd.services = mapAttrs' (
      name: server:
      nameValuePair "minecraft-backup-${name}" {
        description = "Scheduled rclone backup for Minecraft server ${name}";
        wants = [ "network-online.target" ];
        after = [
          "network-online.target"
          "sops-nix.service"
        ];

        path = with pkgs; [
          bash
          findutils
          gnutar
          gzip
          rclone
          systemd
          tmux
        ];

        environment = {
          SERVER_NAME = name;
          RCLONE_REMOTE = server.backup.remote;
          RETENTION_DAYS = toString server.backup.retentionDays;
          RCLONE_SECRET_CONFIG = optionalString (server.backup.rcloneConfigFile != null) (
            toString server.backup.rcloneConfigFile
          );
        };

        serviceConfig = {
          Type = "oneshot";
          User = "minecraft";
          Group = "minecraft";
          EnvironmentFile = optional (server.backup.environmentFile != null) server.backup.environmentFile;
          ExecStart = "${pkgs.bash}/bin/bash ${./backup.sh}";
        };
      }
    ) enabledBackupServers;

    systemd.timers = mapAttrs' (
      name: server:
      nameValuePair "minecraft-backup-${name}" {
        description = "Timer for scheduled rclone backup for Minecraft server ${name}";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = server.backup.calendar;
          Persistent = true;
        };
      }
    ) enabledBackupServers;
  };
}
