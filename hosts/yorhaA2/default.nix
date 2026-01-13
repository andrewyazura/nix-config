{
  lib,
  pkgs,
  inputs,
  ...
}:
let
  username = "andrew";
  hostname = "yorhaA2";
in
{
  imports = [
    ../../darwin
    inputs.private-config.darwinModules.default
  ];

  modules = {
    aerospace.enable = true;
    fonts.enable = true;
    homebrew.enable = true;
    nix.enable = true;
    system-defaults.enable = true;
    work.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    sharedModules = [
      inputs.private-config.homeManagerModules.default
      inputs.sops-nix.homeManagerModules.sops
    ];

    users.${username} = {
      imports = [
        ../../home
        ../../users/andrew/home
        ../../users/andrew/home/yorhaA2
      ];

      modules = {
        ghostty = {
          backgroundOpacity = 0.94;
          fontFamily = "SF Mono";
          fontSize = 12;
          fontStyle = "SemiBold";
        };
      };

      home.homeDirectory = lib.mkForce "/Users/${username}";
    };
  };

  networking.hostName = hostname;
  networking.computerName = hostname;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  environment = {
    systemPackages = with pkgs; [
      age
      colima
      coreutils-prefixed
      docker
      docker-compose
      git
      gnupg
      neovim
      prismlauncher
      yazi
    ];

    variables = {
      DOCKER_HOST = "unix:///Users/${username}/.colima/default/docker.sock";
      TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
      TESTCONTAINERS_HOST_OVERRIDE = "localhost";
    };
  };

  system = {
    stateVersion = 6;
    primaryUser = username;
    defaults.smb.NetBIOSName = hostname;
  };

  time.timeZone = "Europe/Kyiv";
}
