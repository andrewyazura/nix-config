{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.colima;
in
{
  options.modules.colima = {
    enable = mkEnableOption "Enable colima container runtime";
  };

  config = mkIf cfg.enable {
    services.colima = {
      enable = true;
      profiles.default = {
        isActive = true;
        isService = true;
        settings = {
          runtime = "docker";
          vmType = "vz";
          mountType = "virtiofs";
          arch = "host";
          cpu = 4;
          memory = 8;
          disk = 100;
          mounts = [ ];
          network.dnsHosts."host.docker.internal" = "host.lima.internal";
        };
      };
    };

    home = {
      packages = with pkgs; [
        docker-client
        docker-compose
        docker-buildx
      ];

      file = {
        ".docker/cli-plugins/docker-compose".source =
          "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
        ".docker/cli-plugins/docker-buildx".source =
          "${pkgs.docker-buildx}/libexec/docker/cli-plugins/docker-buildx";
      };
    };
  };
}
