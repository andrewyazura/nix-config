{ lib, config, pkgs, inputs, ... }:
with lib;
let
  cfg = config.modules.minecraft-server;
  playerlist = [{
    name = "andrewyazura";
    uuid = "c2eb76fe-7bea-3498-b396-066ba66e08ae"; # offline user
    # uuid = "2629aa63-faec-4548-bdc0-260850cf3cbf"; # online user
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
          package = pkgs.fabricServers.fabric-1_21_10;

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
            max-players = 8;
            motd = "\\u00A7b8 let dambili\\u00A7r";
            online-mode = false;
            white-list = true;
          };
        };
      in {
        main = template // {
          serverProperties = template.serverProperties // {
            server-port = 25566;
          };
        };
        throwaway = template // {
          serverProperties = template.serverProperties // {
            level-seed = "-8393641919666317235";
            server-port = 25567;
            white-list = false;
          };
        };
      };
    };
  };
}
