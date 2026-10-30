{ config, ... }:
let
  exporters = config.services.prometheus.exporters;
  grafanaSecretKey = "${config.services.grafana.dataDir}/secret_key";
in
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1";
    retentionTime = "30d";
    extraFlags = [ "--storage.tsdb.retention.size=4GB" ];
    globalConfig.scrape_interval = "15s";

    exporters = {
      node = {
        enable = true;
        listenAddress = "127.0.0.1";
        enabledCollectors = [
          "systemd"
          "processes"
        ];
        extraFlags = [ "--collector.systemd.enable-restarts-metrics" ];
      };

      postgres = {
        enable = true;
        listenAddress = "127.0.0.1";
        runAsLocalSuperUser = true;
      };

      nginx = {
        enable = true;
        listenAddress = "127.0.0.1";
      };
    };

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [ { targets = [ "127.0.0.1:${toString exporters.node.port}" ]; } ];
      }
      {
        job_name = "postgres";
        static_configs = [ { targets = [ "127.0.0.1:${toString exporters.postgres.port}" ]; } ];
      }
      {
        job_name = "nginx";
        static_configs = [ { targets = [ "127.0.0.1:${toString exporters.nginx.port}" ]; } ];
      }
      {
        job_name = "minecraft";
        scrape_interval = "5s";
        static_configs = [ { targets = [ "127.0.0.1:25585" ]; } ];
      }
    ];

    rules = [
      (builtins.toJSON {
        groups = [
          {
            name = "systemd";
            rules = [
              {
                alert = "ServiceRestarted";
                expr = "increase(node_systemd_service_restart_total[5m]) > 0";
                annotations.summary = "{{ $labels.name }} was restarted automatically";
              }
            ];
          }
        ];
      })
    ];

    alertmanagers = [
      {
        static_configs = [
          { targets = [ "127.0.0.1:${toString config.services.prometheus.alertmanager.port}" ]; }
        ];
      }
    ];

    alertmanager = {
      enable = true;
      listenAddress = "127.0.0.1";
      environmentFile = config.sops.secrets.ntfy-env.path;
      configuration = {
        route = {
          receiver = "ntfy";
          group_by = [
            "alertname"
            "name"
          ];
        };
        receivers = [
          {
            name = "ntfy";
            webhook_configs = [
              {
                url = "http://[::1]:2586/bunker?template=alertmanager";
                send_resolved = false;
                http_config.authorization.credentials = "$NTFY_TOKEN";
              }
            ];
          }
        ];
      };
    };
  };

  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "0.0.0.0";
        http_port = 3000;
      };

      database = {
        type = "postgres";
        host = "/run/postgresql";
        name = "grafana";
        user = "grafana";
      };

      security.secret_key = "$__file{${grafanaSecretKey}}";
    };

    provision = {
      enable = true;
      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://127.0.0.1:${toString config.services.prometheus.port}";
          isDefault = true;
        }
      ];
    };
  };

  systemd.services.grafana.preStart = ''
    if [ ! -s ${grafanaSecretKey} ]; then
      (umask 077; tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 64 > ${grafanaSecretKey})
    fi
  '';

  services.postgresql = {
    ensureDatabases = [ "grafana" ];
    ensureUsers = [
      {
        name = "grafana";
        ensureDBOwnership = true;
      }
    ];
  };

  networking.firewall.interfaces.tailscale0.allowedTCPPorts = [
    config.services.grafana.settings.server.http_port
  ];
}
