{
  users.users.andrew.extraGroups = [ "gamemode" ];

  security.sudo.extraRules = [
    {
      users = [ "andrew" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/nixos-rebuild";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
