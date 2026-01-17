{
  inputs,
  ...
}:
{
  imports = [ inputs.birthday-api-app.nixosModules.default ];

  services.birthday-api = {
    enable = true;
    configFile = "/var/lib/birthday-api/config.ini";
  };

  services.postgresql = {
    ensureDatabases = [ "birthday_api" ];
    ensureUsers = [
      {
        name = "birthday_api";
        ensureDBOwnership = true;
      }
    ];
  };

  systemd.services.birthday-api = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "30s";
    };
  };
}
