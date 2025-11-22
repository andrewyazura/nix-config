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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ghostty = { url = "github:ghostty-org/ghostty"; };
    nix-minecraft = { url = "github:Infinidoge/nix-minecraft"; };

    private-config = {
      url = "git+ssh://git@github.com/andrewyazura/private-nix-config.git";
    };

    duty-reminder-app = { url = "github:andrewyazura/duty-reminder"; };
    birthday-api-app = { url = "github:orehzzz/birthday-api"; };
    birthday-bot-app = { url = "github:orehzzz/birthday-telegram-bot"; };
  };

  outputs = inputs@{ nixpkgs, nix-darwin, ... }:
    let
      mkHost =
        { hostname, system ? "x86_64-linux", specialArgs ? { }, modules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname; } // specialArgs;
          modules = [
            ./system
            ./hosts/${hostname}

            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
          ] ++ modules;
        };
    in {
      nixosConfigurations = {
        yorha2b = mkHost { hostname = "yorha2b"; };

        yorha9s = mkHost {
          hostname = "yorha9s";
          modules = [ inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401 ];
        };

        bunker = mkHost { hostname = "bunker"; };
        proxmoxnix = mkHost { hostname = "proxmoxnix"; };
      };

      darwinConfigurations = {
        yorhaA2 = nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";

          specialArgs = {
            inherit inputs;
            hostname = "yorhaA2";
          };

          modules = [
            ./hosts/yorhaA2

            inputs.home-manager.darwinModules.home-manager
            inputs.sops-nix.darwinModules.sops
          ];
        };
      };
    };
}
