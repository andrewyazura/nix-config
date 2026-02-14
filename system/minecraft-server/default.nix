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
      openFirewall = false;

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
              enforce-secure-profile = false;
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

              symlinks = {
                "server-icon.png" = ./bombas-server-icon.png;
              };
            };
          };

        in
        mapAttrs (
          name: value: recursiveUpdate (recursiveUpdate serverTemplate value) (cfg.servers.${name} or { })
        ) customServers;
    };

    networking.firewall =
      let
        tcpShieldIps = [
          # neoprotect
          "51.195.127.71/32"
          "51.195.127.72/32"
          "51.195.127.90/32"
          "51.195.127.91/32"
          "15.204.187.208/32"
          "15.204.187.209/32"
          "15.204.130.224/32"
          "15.204.131.21/32"
          "54.36.238.155/32"
          "54.36.238.165/32"
          "54.36.238.136/32"
          "54.36.238.139/32"
          "54.36.238.170/32"
          "54.36.238.180/32"
        ];

        allPorts = mapAttrsToList (
          name: server: toString (server.serverProperties.server-port or 25565)
        ) cfg.servers;

        uniquePorts = unique allPorts;
      in
      {
        extraCommands = concatMapStrings (
          port:
          concatMapStrings (ip: ''
            iptables -A INPUT -p tcp -s ${ip} --dport ${port} -j ACCEPT
          '') tcpShieldIps
        ) uniquePorts;

        extraStopCommands = concatMapStrings (port: ''
          iptables -D INPUT -p tcp --dport ${port} -j ACCEPT || true
        '') uniquePorts;
      };
  };
}
