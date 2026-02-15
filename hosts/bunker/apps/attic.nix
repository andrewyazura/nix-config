{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.attic.nixosModules.atticd ];

  services.postgresql = {
    ensureDatabases = [ "atticd" ];
    ensureUsers = [
      {
        name = "atticd";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.atticd = {
    after = [
      "postgresql.service"
      "postgresql-setup.service"
    ];
    requires = [
      "postgresql.service"
      "postgresql-setup.service"
    ];
  };

  services.atticd = {
    enable = true;
    mode = "monolithic";
    environmentFile = config.sops.secrets.attic-env.path;

    settings = {
      listen = "[::]:8080";
      database.url = "postgresql:///atticd";

      storage = {
        type = "local";
        path = "/var/lib/atticd/storage";
      };

      chunking = {
        nar-size-threshold = 65536;
        min-size = 16384;
        avg-size = 65536;
        max-size = 262144;
      };

      garbage-collection = {
        interval = "7 days";
        default-retention-period = "90 days";
      };
    };
  };

  services.nginx.virtualHosts."cache.andrewyazura.com" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."andrewyazura.crt".path;
    sslCertificateKey = config.sops.secrets."andrewyazura.key".path;

    extraConfig = "client_max_body_size 0;";

    locations."/" = {
      proxyPass = "http://[::1]:8080";
      extraConfig = ''
        proxy_read_timeout 100s;
        proxy_send_timeout 100s;
        proxy_connect_timeout 60s;
      '';
    };
  };
}
