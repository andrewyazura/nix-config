{
  config,
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

  systemd.services.minecraft-server-bombas = {
    after = [
      "postgresql.service"
      "postgresql-setup.service"
    ];
    requires = [ "postgresql.service" ];
    wants = [ "postgresql-setup.service" ];
  };
}
