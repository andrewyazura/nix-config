{ config, ... }:
{
  services.ntfy-sh = {
    enable = true;
    environmentFile = config.sops.secrets.ntfy-env.path;

    settings = {
      base-url = "https://ntfy.andrewyazura.com";
      behind-proxy = true;
      auth-default-access = "deny-all";
    };
  };

  services.nginx.virtualHosts."ntfy.andrewyazura.com" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."andrewyazura.crt".path;
    sslCertificateKey = config.sops.secrets."andrewyazura.key".path;

    locations."/" = {
      proxyPass = "http://[::1]:2586";
      proxyWebsockets = true;
      extraConfig = ''
        proxy_buffering off;
        proxy_request_buffering off;
        client_max_body_size 20M;
      '';
    };
  };
}
