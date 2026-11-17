{ config, lib, ... }:
{
  modules = {
    profiles = {
      ai-tools.enable = true;
      desktop.enable = true;
      development.enable = true;
    };

    claude.instances.personal.remoteControl = {
      home = "${config.home.homeDirectory}/Documents/claude";
      nix = "/etc/nix-darwin";
    };
    colima.enable = true;
    ghostty = {
      fontSize = 12;
      fontStyle = "SemiBold";
    };
    ideavim.enable = true;
    tmux.showBattery = true;
  };
  home.stateVersion = "25.05";

  launchd.agents.sops-nix.config.EnvironmentVariables.PATH =
    lib.mkForce "/usr/bin:/bin:/usr/sbin:/sbin";

  sops = {
    age.sshKeyPaths = [ "/Users/andrew/.ssh/id_ed25519_yorhaA2_nixconfig_3011" ];

    secrets = {
      ssh-config = {
        sopsFile = ../../../../secrets/ssh-config;
        format = "binary";
      };
    };
  };

  programs = {
    ssh = {
      includes = [ config.sops.secrets.ssh-config.path ];
      settings = {
        "bunker" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_bunker_1701";
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_github_3011";
        };
      };
    };

    zsh = {
      shellAliases = {
        copy = "pbcopy";
        paste = "pbpaste";
        ls = "ls --color=auto";
      };
      initContent = ''
        export LANGUAGE=en_US.UTF-8

        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
