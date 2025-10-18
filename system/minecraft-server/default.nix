{ lib, config, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.minecraft-server;
  playerlist = [
    {
      name = "andrewyazura";
      uuid = "c2eb76fe-7bea-3498-b396-066ba66e08ae"; # offline user
      # uuid = "2629aa63-faec-4548-bdc0-260850cf3cbf"; # online user
      level = 4;
      bypassesPlayerLimit = false;
    }
    {
      name = "boober";
      uuid = "ecff3058-99c4-3f02-b7e5-154740f59632"; # offline user
      # uuid = "ea38893c-11c9-493d-a285-69916f41f03f"; # online user
      level = 4;
      bypassesPlayerLimit = false;
    }
    {
      name = "chief";
      uuid = "adfadefe-d090-35d2-b71e-b7ed34dfca93"; # offline user
      # uuid = "5aa86e15-6ddd-404e-93bf-71a87f448abc"; # online user
      level = 0;
      bypassesPlayerLimit = false;
    }
    {
      name = "Singualrity";
      uuid = "72271d99-4491-320e-8c32-bf4791c3f384"; # offline user
      # uuid = "d2988641-9838-4fcd-ba0c-0b263205563a"; # online user
      level = 0;
      bypassesPlayerLimit = false;
    }
    {
      name = "Sliparick";
      uuid = "6def2816-d21e-35fa-bb5c-e989bed75acb"; # offline user
      # uuid = "fec0904f-37d5-4e9f-8edc-55c3ed9cdfdf"; # online user
      level = 0;
      bypassesPlayerLimit = false;
    }
    {
      name = "War_of_Lord";
      uuid = "844cb079-11a2-3d18-bc9b-b15a7e1f1751"; # offline user
      # uuid = "3da44920-a9d9-4925-b39c-5d47dfc6051e"; # online user
      level = 0;
      bypassesPlayerLimit = false;
    }
  ];
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
          package = pkgs.fabricServers.fabric-1_21_10;

          operators = listToAttrs (map (p: {
            name = p.name;
            value = removeAttrs p [ "name" ];
          }) (filter (p: p.level > 0) playerlist));

          whitelist = listToAttrs (map (p: {
            name = p.name;
            value = p.uuid;
          }) playerlist);

          serverProperties = {
            allow-cheats = false;
            difficulty = "normal";
            gamemode = "survival";
            max-players = length playerlist;
            online-mode = false;
            white-list = true;
          };
        };
      in {
        main = template // {
          serverProperties = template.serverProperties // {
            motd = "a nixos server";
            server-port = 25566;
          };
        };
        throwaway = template // {
          symlinks = {
            mods = pkgs.linkFarmFromDrvs "mods" (attrValues {
              Fabric-API = pkgs.fetchurl {
                url =
                  "https://cdn.modrinth.com/data/P7dR8mSH/versions/lxeiLRwe/fabric-api-0.136.0%2B1.21.10.jar";
                sha512 =
                  "d6ad5afeb57dc6dbe17a948990fc8441fbbc13a748814a71566404d919384df8bd7abebda52a58a41eb66370a86b8c4f910b64733b135946ecd47e53271310b5";
              };
              DistantHorizons = pkgs.fetchurl {
                url =
                  "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar";
                sha512 =
                  "1b1b70b7ec6290d152a5f9fa3f2e68ea7895f407c561b56e91aba3fdadef277cd259879676198d6481dcc76a226ff1aa857c01ae9c41be3e963b59546074a1fc";
              };
            });
          };
          serverProperties = template.serverProperties // {
            motd = "\\u00A7b8 let dambili\\u00A7r";
            server-port = 25567;
            spawn-protection = 0;
          };
        };
      };
    };
  };
}
