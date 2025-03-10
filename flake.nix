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

  outputs =
    inputs@{ nixpkgs, nixos-hardware, home-manager, minegrub-theme, ... }: {
      nixosConfigurations = {
        r7-x3d = let
          username = "andrew";
          hostname = "r7-x3d";
        in nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/${hostname}
            ./users/${username}/system.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs // {
                inherit username hostname;
              };
              home-manager.users.${username} =
                import ./users/${username}/home.nix;
            }

            minegrub-theme.nixosModules.default
          ];
          specialArgs = { inherit inputs hostname; };
        };

        ga401 = let
          username = "andrew";
          hostname = "ga401";
        in nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./hosts/${hostname}
            ./users/${username}/system.nix
            nixos-hardware.nixosModules.asus-zephyrus-ga401

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs // {
                inherit username hostname;
              };
              home-manager.users.${username} =
                import ./users/${username}/home.nix;
            }
          ];
          specialArgs = { inherit inputs hostname; };
        };

        hetzner-x86_64 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./hosts/hetzner ];
        };
      };
    };
}
