{ lib, config, pkgs, ... }:
with lib;
let cfg = config.modules.minecraft-server;
in {
  options.modules.minecraft-server = {
    enable = mkEnableOption "Enable Minecraft server configuration";
  };

  config = mkIf cfg.enable {
    services.minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      declarative = true;
      package = pkgs.papermcServers.papermc-1_21_5;

      whitelist = { andrewyazura = "2629aa63-faec-4548-bdc0-260850cf3cbf"; };

      serverProperties = {
        difficulty = 3;
        gamemode = 1;
        max-players = 2;
        motd = "NixOS Minecraft server!";
        white-list = false;
        allow-cheats = false;
      };
    };
  };
}
