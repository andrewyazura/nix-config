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
  operators = filter (player: player.level > 0) playerlist;
  operatorsFile = pkgs.writeText "ops.json" ''
    ${builtins.toJSON (map (player: {
      uuid = player.uuid;
      name = player.name;
      level = player.level;
      bypassesPlayerLimit = player.bypassesPlayerLimit;
    }) operators)}
  '';
in {
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  # nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

  options.modules.minecraft-server = {
    enable = mkEnableOption "Enable Minecraft server configuration";
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = let
        template = {
          enable = true;
          package = pkgs.fabricServers.fabric-1_21_5;

          whitelist = listToAttrs (map:
            (player: {
              name = player.name;
              value = player.uuid;
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
              };

              sodium = fetchurl {
                url =
                  "https://cdn.modrinth.com/data/AANobbMI/versions/DA250htH/sodium-fabric-0.6.13%2Bmc1.21.5.jar";
              };

              iris = fetchurl {
                url =
                  "https://cdn.modrinth.com/data/YL57xq9U/versions/U6evbjd0/iris-fabric-1.8.11%2Bmc1.21.5.jar";
              };

              distant-horizons = fetchurl {
                url =
                  "https://cdn.modrinth.com/data/uCdwusMi/versions/Mt9bDAs6/DistantHorizons-neoforge-fabric-2.3.2-b-1.21.5.jar";
              };
            });
          };
        };
      in {
        fabric-main = template // { serverProperties.max-players = 2; };
        fabric-throwaway = template;
      };
    };

    systemd.services.minecraft-server.serviceConfig.ExecStartPre = ''
      ${pkgs.coreutils}/bin/ln -sf ${operatorsFile} ops.json
    '';
  };
}
