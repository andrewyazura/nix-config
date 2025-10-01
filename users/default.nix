{ lib, username, hostname, ... }: {
  imports = [ ./${username}/system ]
    ++ lib.optionals (builtins.pathExists ./${username}/system/${hostname})
    [ ./${username}/system/${hostname} ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    users.${username} = {
      imports = [ ../home ./${username}/home ]
        ++ lib.optionals (builtins.pathExists ./${username}/home/${hostname})
        [ ./${username}/home/${hostname} ];

      home = {
        inherit username;
        homeDirectory = "/home/${username}";

        stateVersion = "24.11";
      };
    };
  };
}
