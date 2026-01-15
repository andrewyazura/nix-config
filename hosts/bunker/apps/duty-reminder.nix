{
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.duty-reminder-app.nixosModules.default ];

  services.duty-reminder = {
    enable = true;
    environment = {
      SERVER_PORT = "10000";
    };
    environmentFile = config.sops.secrets."duty-reminder.env".path;
  };

  # PostgreSQL database configuration
  services.postgresql = {
    ensureDatabases = [ "duty_reminder" ];
    ensureUsers = [
      {
        name = "duty_reminder";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.duty-reminder = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };

  services.nginx.virtualHosts."duty-reminder.andrewyazura.com" = {
    forceSSL = true;
    sslCertificate = config.sops.secrets."andrewyazura.crt".path;
    sslCertificateKey = config.sops.secrets."andrewyazura.key".path;

    locations."/" = {
      proxyPass = "http://127.0.0.1:10000";
    };
  };
}
