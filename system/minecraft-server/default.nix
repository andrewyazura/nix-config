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
            max-players = 5;
            motd = "NixOS Minecraft server!";
            white-list = true;
            allow-cheats = false;
          };
        };
      in {
        main = template // {
          serverProperties = {
            server-port = 25564;
            max-players = 2;
          };
        };
        throwaway = template // {
          serverProperties = {
            server-port = 25565;
            white-list = false;
          };
        };
      };
    };
  };
}
