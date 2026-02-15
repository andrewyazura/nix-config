{ config, ... }:
{
  modules.profiles = {
    development.enable = true;
    desktop.enable = true;
    ai-tools.enable = true;
  };
  home.stateVersion = "24.11";

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha9s_nixconfig_1510" ];
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
          identityFile = "~/.ssh/id_ed25519_yorha9s_bunker_1801";
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorha9s_github_2509";
        };
        "proxmoxnix" = {
          identityFile = "~/.ssh/id_ed25519_yorha9s_proxmoxnix_2510";
        };
      };
    };

    zsh = {
      shellAliases = {
        copy = "xclip -selection clipboard";
      };
    };
  };
}
