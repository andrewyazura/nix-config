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

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    # hyprland = { url = "github:hyprwm/Hyprland"; };
    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
  };

  outputs = inputs@{ nixpkgs, nixos-hardware, ... }: {
    nixosConfigurations = {
      r7-x3d = let
        username = "andrew";
        hostname = "r7-x3d";
      in nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/${hostname} ./users/${username}/system.nix ];
        specialArgs = { inherit inputs username hostname; };
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
        ];
        specialArgs = { inherit inputs username hostname; };
      };

      hetzner-x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./hosts/hetzner ./users/andrew/system.nix ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
