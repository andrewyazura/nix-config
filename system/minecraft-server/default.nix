{ lib, config, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.minecraft-server;
  playerlist = [{
    name = "andrewyazura";
    uuid = "2629aa63-faec-4548-bdc0-260850cf3cbf";
    level = 4;
    bypassesPlayerLimit = true;
  }];
in {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.modules.minecraft-server = {
    enable = mkEnableOption "Enable Minecraft server configuration";
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = let
        template = {
          enable = true;
          package = pkgs.fabricServers.fabric-1_21_5;

          operators = lib.listToAttrs (map (p: {
            name = p.name;
            value = lib.removeAttrs p [ "name" ];
          }) (filter (p: p.level > 0) playerlist));

          whitelist = listToAttrs (map (p: {
            name = p.name;
            value = p.uuid;
          }) playerlist);

          serverProperties = {
            difficulty = "normal";
            gamemode = "survival";
            max-players = 10;
            motd = "NixOS Minecraft server!";
            white-list = true;
            allow-cheats = false;
          };

          symlinks = with pkgs; {
            mods = linkFarmFromDrvs "mods" (builtins.attrValues {
              fabric-api = fetchurl {
                url =
                  "https://cdn.modrinth.com/data/P7dR8mSH/versions/aQqNHHfZ/fabric-api-0.128.1%2B1.21.5.jar";
                sha512 =
                  "9ee7377f1d085d34363f3025a8ea55e3bf6e31732453a9e5ba3c5bd11dcb055636818c85bd55f17ec5f9078d6fa15361a8c302ed093677f5e9d09b4c17d74a41";
              };

              sodium = fetchurl {
                url =
                  "https://cdn.modrinth.com/data/AANobbMI/versions/DA250htH/sodium-fabric-0.6.13%2Bmc1.21.5.jar";
                sha512 =
                  "4cddd0b8f5392278002e6cd4c91f20a9e4b17e7ba38c1a2dcc419ca4b0b856366e247101beedaff9f021664523ab32c51acf7fb4dd2b411367c06f9edeb2108d";
              };

              iris = fetchurl {
                url =
                  "https://cdn.modrinth.com/data/YL57xq9U/versions/U6evbjd0/iris-fabric-1.8.11%2Bmc1.21.5.jar";
                sha512 =
                  "f87af0c7fbfa55657b0c0424dc8f20c9c507e4330a69faa83964b9c76f493be5cb19957937de6550ed220449c3c19cb41cbcfc163a12a72b581331d1d8f2958e";
              };

              distant-horizons = fetchurl {
                url =
                  "https://cdn.modrinth.com/data/uCdwusMi/versions/Mt9bDAs6/DistantHorizons-neoforge-fabric-2.3.2-b-1.21.5.jar";
                sha512 =
                  "e17d845f5ddb71a9ca644875a02b845e045bb5c7e72429e120271636936a816b416bb4ba13789de18c3af6a1a5f5b7ed5dbe07326c60d5c49534a382310dab1f";
              };
            });
          };
        };
      in {
        fabric-main = template // {
          serverProperties = {
            server-port = 43000;
            max-players = 2;
          };
        };
        fabric-throwaway = template // {
          serverProperties = { server-port = 25565; };
        };
      };
    };
  };
}
