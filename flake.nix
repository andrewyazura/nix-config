{
  description = "nix configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    minegrub-theme = { url = "github:Lxtharia/minegrub-theme"; };

    ghostty = { url = "github:ghostty-org/ghostty"; };
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, home-manager, ... }: {
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

      ga401 = let username = "andrew";
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/ga401
          ./users/${username}/system.nix
          nixos-hardware.nixosModules.asus-zephyrus-ga401

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = inputs  // { inherit username; };
            home-manager.users.${username} = 
              import ./users/${username}/home.nix;
          }
        ];
        specialArgs = {inherit inputs;};
      };

      hetzner-x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/hetzner
        ];
      };
    };
  };
}
