{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.attic.nixosModules.atticd ];

  services.atticd = {
    enable = true;
    mode = "monolithic";
    environmentFile = config.sops.secrets.attic-env.path;

    settings = {
      listen = "[::]:8080";
      database.url = "sqlite:///var/lib/atticd/server.db?mode=rwc";

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
    };
  };
}
