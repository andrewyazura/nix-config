{ inputs, hostname, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs hostname;
    };
    sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
  };
}
