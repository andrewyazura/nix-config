{
  inputs,
  ...
}:
{
  imports = [ inputs.birthday-bot-app.nixosModules.default ];

  services.birthday-bot = {
    enable = true;
    configFile = "/var/lib/birthday-bot/config.ini";
  };
}
