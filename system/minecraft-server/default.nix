{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib;
let
  cfg = config.modules.minecraft-server;
in
{
  imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

  options.modules.minecraft-server = {
    enable = mkEnableOption "Enable Minecraft server configuration";

    servers = mkOption {
      type = types.attrsOf (
        types.submodule ({
          options = {
            jvmOpts = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "JVM options for the server";
            };

            serverProperties = mkOption {
              type =
                with types;
                attrsOf (oneOf [
                  bool
                  int
                  str
                ]);
              default = { };
              description = "Propeties for the server.properties file";
            };
          };
        })
      );

      default = { };
      description = "Per-server configuration overrides";
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers =
        let
          players = import ./players.nix;
          mods = import ./mods.nix { inherit pkgs; };

          serverTemplate = {
            enable = true;
            package = pkgs.fabricServers.fabric-1_21_11;

            symlinks.mods = pkgs.linkFarmFromDrvs "mods" (attrValues mods);

            operators = players.toOperators players.offline;
            whitelist = players.toWhitelist players.offline;

            serverProperties = {
              difficulty = "normal";
              gamemode = "survival";
              max-players = length players.list;
              online-mode = false;
              spawn-protection = 0;
              white-list = true;
            };
          };

          customServers = {
            bombas = {
              serverProperties = {
                motd = "\\u00A7a\\u00A7l8 let dambili\\u00A7r\\u00A7r";
              };

              files = {
                "server-icon.png" = ./bombas-server-icon.png;
              };
            };
          };

        in
        mapAttrs (
          name: value: recursiveUpdate (recursiveUpdate serverTemplate value) (cfg.servers.${name} or { })
        ) customServers;
    };
  };
}
