{
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
