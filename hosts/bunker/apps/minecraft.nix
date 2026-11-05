{
  config,
  lib,
  pkgs,
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
      files."config/GrimAC/database.yml" = ./grim-database.yml;
      files."config/GrimAC/databases/postgres.yml" = ./grim-postgres.yml;

      files."config/luckperms/luckperms.conf" = {
        format = pkgs.formats.json { };
        value = {
          storage-method = "postgresql";
          data = {
            address = "localhost";
            database = "luckperms";
            username = "luckperms";
            password = "@LUCKPERMS_DB_PASSWORD@";
          };
        };
      };

      files."config/EasyAuth/storage.conf" = {
        format = pkgs.formats.json { };
        value = {
          database-type = "postgresql";
          postgresql = {
            pg-host = "localhost:5432";
            pg-user = "easyauth";
            pg-password = "@EASYAUTH_DB_PASSWORD@";
            pg-database = "easyauth";
            pg-table = "easyauth";
          };
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
    ensureDatabases = [
      "ledger"
      "luckperms"
      "grim"
      "easyauth"
    ];
    ensureUsers = [
      {
        name = "ledger";
        ensureDBOwnership = true;
        ensureClauses.password = "SCRAM-SHA-256$4096:ze6rInlcwrIvJLDrPZAceg==$2NOR3ZX6nqFYvRRQGRm/d3seyxWV5+4T+NEEJzaq/XU=:teMU+j8Dpt8T97dzRwoobXj+pHBg6u2zs5qFh3oogs0=";
      }
      {
        name = "luckperms";
        ensureDBOwnership = true;
        ensureClauses.password = "SCRAM-SHA-256$4096:i58oP0lK6voLAQdRwYAuAQ==$BOgh4rYqw6p46tmHW9/VySCF7T8OaOotoU+i93bWCmA=:J7uBW5sJygdgG4rW/QFaIP+pEyUufOVdDTtbjjhlo2s=";
      }
      {
        name = "grim";
        ensureDBOwnership = true;
        ensureClauses.password = "SCRAM-SHA-256$4096:GhBAmMRBzpR55iy6KhrtzA==$9UF9mb+6Fj378WB+IH9/NLgssft/E/4+upItu0R+qKU=:x8Ou6h/FBPjgC/yJAqQn08WDXuLSlpaQXEw+lPpOwSQ=";
      }
      {
        name = "easyauth";
        ensureDBOwnership = true;
        ensureClauses.password = "SCRAM-SHA-256$4096:A0ukIKW7RcvYYdUrC1Lg2A==$8hQQ7VrUZqaxj1dLxOgxPdWTzP+XH6pqWKbMKw1VlZI=:nb3EQyYwCTnAdrgA4/CSaz/xOvmbw8vtjBc0cEGScCU=";
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

    grim-grafana-grants = {
      after = [ "postgresql.target" ];
      wants = [ "postgresql.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
        ExecStart = "${lib.getExe' config.services.postgresql.finalPackage "psql"} -d grim -v ON_ERROR_STOP=1 --single-transaction -f ${./grim-grafana.sql}";
      };
    };
  };
}
