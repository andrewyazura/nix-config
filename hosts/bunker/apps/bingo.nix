{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.bingo-app.nixosModules.default ];

  services.bingo = {
    enable = true;
    port = 8081;
    domain = "bin9o.click";
    databaseUrl = "postgresql:///bingo?host=/run/postgresql";
  };

  services.nginx.virtualHosts."bin9o.click" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."bin9o.crt".path;
    sslCertificateKey = config.sops.secrets."bin9o.key".path;
  };

  services.postgresql = {
    ensureDatabases = [ "bingo" ];
    ensureUsers = [
      {
        name = "bingo";
        ensureDBOwnership = true;
      }
    ];
  };
}
