{
  config,
  lib,
  ...
}:
{
  modules.minecraft-server = {
    enable = true;

    servers.bombas = {
      jvmOpts = "-Xms8192M -Xmx8192M -XX:+ExitOnOutOfMemoryError";
      environmentFile = config.sops.secrets.minecraft-ledger-env.path;

      serverProperties = {
        server-port = 25565;
      };

      files."config/ledger.toml".value = {
        networking.networking = false;

        database_extensions = {
          database = "POSTGRESQL";
          url = "localhost/ledger";
          username = "ledger";
          password = "@LEDGER_DB_PASSWORD@";
        };
      };

      files."config/GrimAC/punishments.yml" = ./grim-punishments.yml;

      backup = {
        enable = true;
        remote = "gdrive-minecraft-backups:minecraft-backups";
        rcloneConfigFile = config.sops.secrets.rclone-config.path;
        calendar = "04:00";
        retentionDays = 1;
      };
    };
  };

  services.postgresql = {
    ensureDatabases = [ "ledger" ];
    ensureUsers = [
      {
        name = "ledger";
        ensureDBOwnership = true;
        ensureClauses.password = "SCRAM-SHA-256$4096:ze6rInlcwrIvJLDrPZAceg==$2NOR3ZX6nqFYvRRQGRm/d3seyxWV5+4T+NEEJzaq/XU=:teMU+j8Dpt8T97dzRwoobXj+pHBg6u2zs5qFh3oogs0=";
      }
    ];
  };

  systemd.services = {
    minecraft-server-bombas = {
      after = [ "postgresql.target" ];
      requires = [ "postgresql.target" ]; # TODO: check if ledger can reconnect to postgres without restarting minecraft server. any changes to postgresql might break connection between ledger and postgres, and complete server restart ensures ledger reconnects. if ledger is capable of reconnecting, drop requires= and only use wants=
      wants = [ "postgresql.target" ];
    };

    ledger-grafana-grants = {
      after = [ "postgresql.target" ];
      wants = [ "postgresql.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
        ExecStart = "${lib.getExe' config.services.postgresql.finalPackage "psql"} -d ledger -v ON_ERROR_STOP=1 --single-transaction -f ${./ledger-grafana.sql}";
      };
    };
  };
}
