{ lib, config, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.minecraft-server;
  players = let
    mkPlayer = name: offlineUuid: onlineUuid: level: bypassesPlayerLimit: {
      inherit name offlineUuid onlineUuid level bypassesPlayerLimit;
    };
  in [
    (mkPlayer "andrewyazura" "c2eb76fe-7bea-3498-b396-066ba66e08ae"
      "2629aa63-faec-4548-bdc0-260850cf3cbf" 4 false)
    (mkPlayer "boober" "ecff3058-99c4-3f02-b7e5-154740f59632"
      "ea38893c-11c9-493d-a285-69916f41f03f" 4 false)
    (mkPlayer "chief" "adfadefe-d090-35d2-b71e-b7ed34dfca93"
      "5aa86e15-6ddd-404e-93bf-71a87f448abc" 0 false)
    (mkPlayer "Singualrity" "72271d99-4491-320e-8c32-bf4791c3f384"
      "d2988641-9838-4fcd-ba0c-0b263205563a" 0 false)
    (mkPlayer "Sliparick" "6def2816-d21e-35fa-bb5c-e989bed75acb"
      "fec0904f-37d5-4e9f-8edc-55c3ed9cdfdf" 0 false)
    (mkPlayer "War_of_Lord" "844cb079-11a2-3d18-bc9b-b15a7e1f1751"
      "3da44920-a9d9-4925-b39c-5d47dfc6051e" 0 false)
    (mkPlayer "Prorab_Vitya" "e53b149e-f0c2-3ff5-94eb-2980d2d63ea2"
      "3daa0578-ab59-406e-9d8c-baf24cbe9bdc" 0 false)
    (mkPlayer "Fannera" "6507a34d-c795-3211-8a0c-61732ad90b96"
      "47803ac2-9f82-4c7c-bb6b-d5536eaca3e9" 0 false)
    (mkPlayer "Raidzin" "1115c914-a480-35ae-829b-3d70a17aa436"
      "336f30af-8c87-4447-809b-af5ea7d2abbc" 0 false)
    (mkPlayer "GameMax" "e249f570-bf3b-3ff3-aa8a-12a5909698ca"
      "c0f697f2-8300-4725-ab4e-9de702b5fc21" 0 false) # TODO: delete
  ];

  onlinePlayers = map (p: {
    inherit (p) name level bypassesPlayerLimit;
    uuid = p.onlineUuid;
  }) players;

  offlinePlayers = map (p: {
    inherit (p) name level bypassesPlayerLimit;
    uuid = p.offlineUuid;
  }) players;

  toWhitelist = players:
    listToAttrs (map (p: {
      name = p.name;
      value = p.uuid;
    }) players);

  toOperators = players:
    listToAttrs (map (p: {
      name = p.name;
      value = removeAttrs p [ "name" ];
    }) (builtins.filter (p: p.level > 0) players));

in {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.modules.minecraft-server = {
    enable = mkEnableOption "Enable Minecraft server configuration";
    servers = mkOption {
      type = types.attrsOf (types.submodule ({
        options.jvmOpts = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "JVM options for the server";
        };
      }));

      default = { };
      description = "Per-server configuration overrides.";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = let
        mods = with pkgs; {
          "fabric-api" = fetchurl {
            url =
              "https://cdn.modrinth.com/data/P7dR8mSH/versions/lxeiLRwe/fabric-api-0.136.0%2B1.21.10.jar";
            sha512 =
              "d6ad5afeb57dc6dbe17a948990fc8441fbbc13a748814a71566404d919384df8bd7abebda52a58a41eb66370a86b8c4f910b64733b135946ecd47e53271310b5";
          };
          "distant-horizons" = fetchurl {
            url =
              "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar";
            sha512 =
              "1b1b70b7ec6290d152a5f9fa3f2e68ea7895f407c561b56e91aba3fdadef277cd259879676198d6481dcc76a226ff1aa857c01ae9c41be3e963b59546074a1fc";
          };
          "skin-restorer" = fetchurl {
            url =
              "https://cdn.modrinth.com/data/ghrZDhGW/versions/MKWfnXfO/skinrestorer-2.4.3%2B1.21.9-fabric.jar";
            sha512 =
              "a377133467707b88834642660a3a42137acb8abfbf80dbca87508b701aa4aca3e9d1738ef3fc098627c760e6afdea32fcdf8a5835942d291ef0640f3ef3667c5";
          };
          "lithium" = fetchurl {
            url =
              "https://cdn.modrinth.com/data/gvQqBUqZ/versions/oGKQMdyZ/lithium-fabric-0.20.0%2Bmc1.21.10.jar";
            sha512 =
              "755c0e0fc7f6f38ac4d936cc6023d1dce6ecfd8d6bdc2c544c2a3c3d6d04f0d85db53722a089fa8be72ae32fc127e87f5946793ba6e8b4f2c2962ed30d333ed2";
          };
          "very-many-players" = fetchurl {
            url =
              "https://cdn.modrinth.com/data/wnEe9KBa/versions/ppncuwIK/vmp-fabric-mc1.21.10-0.2.0%2Bbeta.7.215-all.jar";
            sha512 =
              "4c8026c7a2ee1cfd6b4113565543f87874e5da755640123561371f7ef0bf8d86e0ea4aadd5f96ee527b3903db5b3f01c00cb8052f72e802cee2dd4f32830df59";
          };
        };

        server-template = {
          enable = true;
          package = pkgs.fabricServers.fabric-1_21_10;

          symlinks.mods = pkgs.linkFarmFromDrvs "mods" (attrValues mods);
          files = {
            "world/datapacks/vanilla-tweaks.zip" = pkgs.fetchurl {
              url =
                "https://vanillatweaks.net/download/VanillaTweaks_c339670_MC1.21-1.21.10.zip";
              sha512 =
                "0hmbmy55bllkrs0sinfzfcdsm5n5fyyfv5449qxd8w78pyfby7dz4lh9j97m3bvwghrjhy6s4fg3w71amcqfwygzbhic3p7qbsrbi63";
            };
          };

          operators = toOperators offlinePlayers;
          whitelist = toWhitelist offlinePlayers;

          serverProperties = {
            difficulty = "normal";
            gamemode = "survival";
            max-players = length players;
            online-mode = false;
            spawn-protection = 0;
            white-list = true;
          };
        };
      in {
        bombas = server-template // {
          serverProperties = server-template.serverProperties // {
            motd = "\\u00A7a\\u00A7l8 let dambili\\u00A7r\\u00A7r";
            server-port = 25567;
          };

          files = server-template.files // {
            "server-icon.png" = ./bombas-server-icon.png;
          };
        } // (cfg.servers.bombas or { });
      };
    };
  };
}
