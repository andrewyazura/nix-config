{ username, hostname, ... }: {
  imports = [ ./${username} ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    users.${username} = {
      imports = [ ../home ./${username}/home ./${username}/home/${hostname} ];

      home = {
        inherit username;
        homeDirectory = "/home/${username}";

        stateVersion = "24.11";
      };
    };
  };
}
