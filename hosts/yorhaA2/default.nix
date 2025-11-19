{ lib, pkgs, inputs, ... }:
let
  username = "andrew";
  hostname = "yorhaA2";
in {
  imports = [ ../../darwin inputs.private-config.darwinModules.default ];

  modules = {
    aerospace.enable = true;
    fonts.enable = true;
    homebrew = {
      enable = true;
      extraCasks = [
        "bitwarden"
        "firefox"
        "ghostty"
        "obsidian"
        "signal"
        "slack"
        "sol"
        "spotify"
      ];
    };
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
      imports =
        [ ../../home ../../users/andrew/home ../../users/andrew/home/yorhaA2 ];

      modules = {
        btop.enable = true;
        ghostty = {
          enable = true;
          fontSize = 12;
          backgroundOpacity = 0.95;
        };
        git.enable = true;
        neovim.enable = true;
        ssh.enable = true;
        work.enable = true;
        yazi.enable = true;
        zsh.enable = true;
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
      colima
      coreutils-prefixed
      docker
      docker-compose
      git
      gnupg
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

    activationScripts.postActivation.text = ''
      sudo -u ${username} hidutil property --matching '{"VendorID": 12771}' --set '{"UserKeyMapping":[
        {"HIDKeyboardModifierMappingSrc":0x7000000E2,"HIDKeyboardModifierMappingDst":0x7000000E3},
        {"HIDKeyboardModifierMappingSrc":0x7000000E3,"HIDKeyboardModifierMappingDst":0x7000000E2},
        {"HIDKeyboardModifierMappingSrc":0x7000000E0,"HIDKeyboardModifierMappingDst":0x7000000E0}
      ]}'
    '';
  };

  time.timeZone = "Europe/Kyiv";
}
