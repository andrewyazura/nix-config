let username = "minecraft-server";
in {
  imports = [ ../../system ];

  users.users.${username} = {
    isNormalUser = true;
    description = "Minecraft Server";
  };

  home-manager = {
    users.${username} = import ../../users/${username}/home.nix;
  };
}
