{
  description = "nix configuration";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };

    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };

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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    claude-code = {
      url = "github:sadjow/claude-code-nix";
    };

    opencode = {
      url = "github:aodhanhayter/opencode-flake";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    private-config = {
      url = "git+ssh://git@github.com/andrewyazura/private-nix-config.git";
    };

    birthday-api-app = {
      url = "github:orehzzz/birthday-api";
    };

    birthday-bot-app = {
      url = "github:orehzzz/birthday-telegram-bot";
    };

    stresses-bot-app = {
      url = "git+ssh://git@github.com/yaroslavpashynskyi/stresses-bot-nix.git";
    };

    beast-music-app = {
      url = "git+ssh://git@github.com/yaroslavpashynskyi/BeastMusic.git";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      deploy-rs,
      ...
    }:
    let
      mkHost =
        {
          hostname,
          system ? "x86_64-linux",
          specialArgs ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname;
          }
          // specialArgs;
          modules = [
            ./system
            ./hosts/${hostname}

            inputs.home-manager.nixosModules.home-manager
            inputs.sops-nix.nixosModules.sops
          ];
        };

      mkDarwinHost =
        {
          hostname,
          system ? "aarch64-darwin",
          specialArgs ? { },
        }:
        nix-darwin.lib.darwinSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname;
          }
          // specialArgs;
          modules = [
            ./hosts/${hostname}

            inputs.home-manager.darwinModules.home-manager
            inputs.sops-nix.darwinModules.sops
          ];
        };
    in
    {
      nixosConfigurations = {
        yorha2b = mkHost { hostname = "yorha2b"; };
        yorha9s = mkHost { hostname = "yorha9s"; };

        bunker = mkHost { hostname = "bunker"; };
        proxmoxnix = mkHost { hostname = "proxmoxnix"; };
      };

      darwinConfigurations = {
        yorhaA2 = mkDarwinHost { hostname = "yorhaA2"; };
      };

      deploy.nodes.bunker = {
        hostname = "bunker";

        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.bunker;
        };
      };

      formatter = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt
      );
    };
}
