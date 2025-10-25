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

    birthday-api-app = { url = "github:olehzzz/birthday-api"; };
    birthday-bot-app = { url = "github:olehzzz/birthday-telegram-bot"; };
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      mkHost = { system ? "x86_64-linux", hostname, users, specialArgs ? { }
        , modules ? [ ] }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname users; } // specialArgs;
          modules = [
            ./hosts
            ./system
            ./users
            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
          ] ++ modules;
        };
    in {
      nixosConfigurations = {
        yorha2b = mkHost {
          hostname = "yorha2b";
          users = [ "andrew" ];
        };

        yorha9s = mkHost {
          hostname = "yorha9s";
          users = [ "andrew" ];
          modules = [ inputs.nixos-hardware.nixosModules.asus-zephyrus-ga401 ];
        };

        bunker = mkHost {
          hostname = "bunker";
          users = [ "andrew" ];
          modules = [
            inputs.duty-reminder-app.nixosModules.default
            inputs.birthday-api-app.nixosModules.default
            inputs.birthday-bot-app.nixosModules.default
          ];
        };

        proxmoxnix = mkHost { hostname = "proxmoxnix"; };
      };
    };
}
