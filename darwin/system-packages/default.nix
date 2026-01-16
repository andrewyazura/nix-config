{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.modules.darwin-packages;
in
{
  options.modules.darwin-packages = {
    docker.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Docker stack (colima, docker, docker-compose)";
    };

    gnuTools.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable GNU coreutils with g prefix";
    };
  };

  config = mkMerge [
    (mkIf cfg.docker.enable {
      environment.systemPackages = with pkgs; [
        colima
        docker
        docker-compose
      ];

      environment.variables = {
        DOCKER_HOST = "unix:///Users/\${USER}/.colima/default/docker.sock";
        TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
        TESTCONTAINERS_HOST_OVERRIDE = "localhost";
      };
    })

    (mkIf cfg.gnuTools.enable {
      environment.systemPackages = with pkgs; [
        coreutils
      ];
    })
  ];
}
