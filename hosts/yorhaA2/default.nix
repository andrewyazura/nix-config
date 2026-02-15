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
    profiles.desktop.enable = true;

    nix.enable = true;
    work.enable = true;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs hostname; };
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
          fontFamily = "SF Mono";
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
      # GPG for encryption
      gnupg
    ];
  };

  system = {
    stateVersion = 6;
    primaryUser = username;
    defaults.smb.NetBIOSName = hostname;
  };

  time.timeZone = "Europe/Warsaw";
}
