{ inputs, hostname, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = inputs // { inherit hostname; };
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };
}
