{
  inputs,
  config,
  ...
}:
{
  imports = [ inputs.beast-music-app.nixosModules.default ];

  services.beastmusic = {
    enable = true;
    envFile = "/var/lib/beastmusic/.env";
    dataDir = "/var/lib/beastmusic";
  };

  services.nginx.virtualHosts."lelomed.andrewyazura.com" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."andrewyazura.crt".path;
    sslCertificateKey = config.sops.secrets."andrewyazura.key".path;

    locations."/" = {
      proxyPass = "http://127.0.0.1:5000";
    };
  };
}
