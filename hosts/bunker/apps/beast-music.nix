{
  inputs,
  ...
}:
{
  imports = [ inputs.beast-music-app.nixosModules.default ];

  services.beastmusic = {
    enable = true;
    envFile = "/var/lib/beastmusic/.env";
    dataDir = "/var/lib/beastmusic";
  };
}
