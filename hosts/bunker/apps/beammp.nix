{ config, ... }:
{
  virtualisation.oci-containers.containers.beammp-server = {
    image = "rouhim/beammp-server:latest";
    ports = [
      "3814:3814/tcp"
      "3814:3814/udp"
    ];
    volumes = [
      "/var/lib/beammp-server/client-mods:/beammp/Resources/Client"
      "/var/lib/beammp-server/server-mods:/beammp/Resources/Server"
    ];
    environmentFiles = [ config.sops.secrets.beammp-env.path ];
  };

  systemd.services."podman-beammp-server".after = [ "sops-nix.service" ];

  networking.firewall.allowedTCPPorts = [ 3814 ];
  networking.firewall.allowedUDPPorts = [ 3814 ];
}
