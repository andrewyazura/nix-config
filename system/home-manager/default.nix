{ inputs, username, hostname, ... }: {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = inputs // { inherit username hostname; };
    users.${username} = import ../../users/${username}/home.nix;
  };
}
