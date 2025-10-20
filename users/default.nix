{ lib, username, hostname, ... }:
let
  mkOptionalImport = path:
    lib.optionals (builtins.pathExists path) [ path ];
in {
  imports = [ ./${username}/system ]
    ++ mkOptionalImport ./${username}/system/${hostname};

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  home-manager = {
    users.${username} = {
      imports = [ ../home ./${username}/home ]
        ++ mkOptionalImport ./${username}/home/${hostname};

      home = {
        inherit username;
        homeDirectory = "/home/${username}";

        stateVersion = "24.11";
      };
    };
  };
}
