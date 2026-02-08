{
  inputs,
  ...
}:
{
  imports = [ inputs.stresses-bot-app.nixosModules.default ];

  services.stresses-bot = {
    enable = true;
    dataDir = "/var/lib/stresses-bot";
  };
}
