{
  config,
  lib,
  pkgs,
  ...
}:
let
  databases = [
    "ledger"
    "luckperms"
    "grim"
    "easyauth"
  ];
in
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
    };
  };

  services.postgresql = {
    ensureDatabases = databases;
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
      { name = "minecraft"; }
    ];
  };

  services.restic.backups.minecraft-bombas = {
    user = "minecraft";
    repository = "rclone:gdrive-minecraft-backups:restic/minecraft-bombas";
    passwordFile = config.sops.secrets.restic-password-minecraft.path;
    rcloneConfigFile = config.sops.secrets.rclone-config.path;
    initialize = true;
    paths = [ "/var/lib/restic-staging/bombas" ];
    timerConfig = {
      OnCalendar = "*-*-* 04:00:00";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 14"
      "--keep-weekly 8"
      "--keep-monthly 12"
    ];
    backupPrepareCommand = lib.getExe (
      pkgs.writeShellApplication {
        name = "restic-prepare-minecraft-bombas";
        runtimeInputs = [
          pkgs.coreutils
          pkgs.findutils
          pkgs.gnugrep
          pkgs.rsync
          pkgs.systemd
          pkgs.tmux
          config.services.postgresql.finalPackage
        ];
        text = ''
          staging=/var/lib/restic-staging/bombas
          log=/srv/minecraft/bombas/logs/latest.log

          console() {
            tmux -S /run/minecraft/bombas.sock send-keys C-u "$1" Enter
          }

          wait_for_save() {
            local inode=$1 size=$2 from
            for _ in $(seq 120); do
              from=$((size + 1))
              if [ "$(stat -c %i "$log")" != "$inode" ]; then
                from=1
              fi
              if tail -c +"$from" "$log" | grep -E '^\[[0-9:]+\] \[Server thread/INFO\]: (System chat: )?Saved the game$' > /dev/null; then
                return 0
              fi
              sleep 1
            done
            echo "no 'Saved the game' in $log after 120 s" >&2
            return 1
          }

          mkdir -p "$staging/world" "$staging/db"

          running=false
          if systemctl is-active --quiet minecraft-server-bombas.service; then
            running=true
          fi

          if $running; then
            trap 'console save-on' EXIT
            read -r inode size < <(stat -c '%i %s' "$log")
            console save-off
            console 'save-all flush'
            wait_for_save "$inode" "$size"
          fi

          rsync -a --delete /srv/minecraft/bombas/world/ "$staging/world/"

          find "$staging/db" -mindepth 1 -delete
          for db in ${lib.escapeShellArgs databases}; do
            pg_dump "$db" > "$staging/db/$db.sql"
          done

          if $running; then
            console save-on
            trap - EXIT
          fi
        '';
      }
    );
  };

  systemd.services = {
    restic-backups-minecraft-bombas = {
      after = [
        "postgresql.target"
        "minecraft-dump-grants.service"
      ];
      wants = [ "postgresql.target" ];
      serviceConfig = {
        StateDirectory = "restic-staging/bombas";
        StateDirectoryMode = "0700";
      };
    };

    restic-backups-postgres.environment.EXCLUDE_DATABASES = lib.concatStringsSep " " databases;

    minecraft-dump-grants = {
      after = [ "postgresql.target" ];
      wants = [ "postgresql.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
        ExecStart = "${lib.getExe' config.services.postgresql.finalPackage "psql"} -d postgres -v ON_ERROR_STOP=1 --single-transaction -f ${pkgs.writeText "minecraft-dump-grants.sql" "GRANT ${lib.concatStringsSep ", " databases} TO minecraft;\n"}";
      };
    };

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
