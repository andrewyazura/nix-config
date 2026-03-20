{ config, ... }:
{
  virtualisation.oci-containers.containers.beammp-server = {
    image = "ich777/beammp-server:latest";
    ports = [
      "3814:3814/tcp"
      "3814:3814/udp"
    ];
    volumes = [ "/var/lib/beammp-server:/server" ];
    environmentFiles = [ config.sops.secrets.beammp-env.path ];
  };

  sops.secrets.beammp-env = {
    sopsFile = ../../../secrets/beammp-env;
    format = "dotenv";
  };

  networking.firewall.allowedTCPPorts = [ 3814 ];
  networking.firewall.allowedUDPPorts = [ 3814 ];
}
