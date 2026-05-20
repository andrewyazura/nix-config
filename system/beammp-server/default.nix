{ lib, config, ... }:
with lib;
let
  cfg = config.modules.beammp-server;
in
{
  options.modules.beammp-server = with types; {
    enable = mkEnableOption "Enable BeamMP server configuration";

    servers = mkOption {
      default = { };
      type = attrsOf (submodule {
        options = {
          port = mkOption {
            type = int;
          };

          environmentFiles = mkOption {
            type = listOf str;
            default = [ ];
          };
        };
      });
    };
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = mapAttrs' (
      name: v:
      nameValuePair "beammp-${name}" {
        image = "rouhim/beammp-server@sha256:049404da7e9e3c7fdf7f18d1bd21489ca4ac607f08630fd4cf3298966d5e6821";
        ports = [
          "${toString v.port}:${toString v.port}/tcp"
          "${toString v.port}:${toString v.port}/udp"
        ];
        extraOptions = [
          "--tty"
          "--interactive"
        ];
        volumes = [
          "/var/lib/beammp/${name}/client-mods:/beammp/Resources/Client"
          "/var/lib/beammp/${name}/server-mods:/beammp/Resources/Server"
        ];
        environmentFiles = v.environmentFiles;
      }
    ) cfg.servers;

    networking.firewall.allowedTCPPorts = mapAttrsToList (name: v: v.port) cfg.servers;
    networking.firewall.allowedUDPPorts = mapAttrsToList (name: v: v.port) cfg.servers;

    systemd.services = mapAttrs' (
      name: v:
      nameValuePair "podman-beammp-${name}" {
        after = [ "sops-nix.service" ];
      }
    ) cfg.servers;
  };
}
