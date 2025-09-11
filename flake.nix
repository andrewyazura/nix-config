{
  description = "nix configuration";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = { url = "github:ghostty-org/ghostty"; };
    nix-minecraft = { url = "github:Infinidoge/nix-minecraft"; };
    duty-reminder-app = { url = "github:andrewyazura/duty-reminder"; };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      mkHost = { system ? "x86_64-linux", hostname, username, specialArgs ? { }
        , modules }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname username; } // specialArgs;
          modules = [ ./system ./hosts/${hostname} ./users/${username} ]
            ++ modules;
        };
    in {
      nixosConfigurations = {
        r7-x3d = mkHost {
          hostname = "r7-x3d";
          username = "andrew";
          modules = [ ];
        };

        ga401 = mkHost {
          hostname = "ga401";
          username = "andrew";
          modules = [ inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401 ];
        };

        hetzner = mkHost {
          hostname = "hetzner";
          username = "andrew";
          modules = [
            inputs.duty-reminder-app.nixosModules.default
            inputs.sops-nix.nixosModules.sops
          ];
        };
      };
    };
}
