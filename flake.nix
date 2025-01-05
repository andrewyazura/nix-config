{
  description = "nix configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    minegrub-theme = { url = "github:Lxtharia/minegrub-theme"; };

    ghostty = { url = "github:ghostty-org/ghostty"; };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      r7-x3d = let username = "andrew";
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/r7-x3d
          ./users/${username}/system.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs // { inherit username; };
            home-manager.users.${username} =
              import ./users/${username}/home.nix;
          }

          inputs.minegrub-theme.nixosModules.default
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
