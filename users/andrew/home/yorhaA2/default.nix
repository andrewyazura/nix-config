{ config, ... }:
{
  modules = {
    claude.enable = true;
    gemini.enable = true;
    work.enable = true;

    # Desktop-specific packages
    packages = {
      shell.enable = true;
      media.enable = true;
      ai.enable = true;
    };
  };
  home.stateVersion = "25.05";

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
      matchBlocks = {
        "bunker" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_bunker_0112";
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_github_3011";
        };
        "proxmoxnix" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_proxmoxnix_0112";
        };
      };
    };

    zsh = {
      shellAliases = {
        copy = "pbcopy";
        ls = "gls --color=auto";
      };
      initContent = ''
        export LANGUAGE=en_US.UTF-8

        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
