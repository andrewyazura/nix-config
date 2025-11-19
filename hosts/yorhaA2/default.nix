{ lib, pkgs, inputs, ... }:
let
  username = "andrew";
  hostname = "yorhaA2";
in {
  imports = [ ../../darwin inputs.private-config.darwinModules.default ];

  modules = {
    aerospace.enable = true;
    homebrew = {
      enable = true;
      extraCasks =
        [ "bitwarden" "firefox" "ghostty" "obsidian" "slack" "sol" "spotify" ];
    };
    nix.enable = true;
    system-defaults = {
      enable = true;
      keyboard.swapLeftCtrlAndFn = true;
    };
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
        };
        git.enable = true;
        neovim.enable = true;
        ssh.enable = true;
        work.enable = true;
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

  environment.systemPackages = with pkgs; [ coreutils-prefixed git gnupg ];

  system = {
    stateVersion = 6;
    primaryUser = username;
    defaults.smb.NetBIOSName = hostname;
  };

  time.timeZone = "Europe/Kyiv";
}
