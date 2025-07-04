let username = "minecraft-server";
in {
  imports = [ ../../home ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.11";
  };
}
