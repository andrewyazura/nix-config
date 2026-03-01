{ config, ... }:
{
  modules = {
    profiles = {
      development.enable = true;
      desktop.enable = true;
      ai-tools.enable = true;
    };

    neovim.vaultPath = "~/Documents/notes";
  };
  home.stateVersion = "24.11";

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha2b_nixconfig_1510" ];
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
          identityFile = "~/.ssh/id_ed25519_yorha2b_bunker_1801";
        };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorha2b_github_1110";
        };
      };
    };

    zsh = {
      shellAliases = {
        copy = "wl-copy";
      };
    };
  };
}
