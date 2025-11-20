{ config, ... }: {
  modules = {
    stuff.enable = true;
    work.enable = true;
  };
  home.stateVersion = "24.11";

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha9s_nixconfig_1510" ];
    secrets = {
      ssh-config = {
        sopsFile = ../../../../secrets/ssh-config;
        format = "binary";
      };
      anthropic-api-key = {
        sopsFile = ../../../../secrets/anthropic-api-key;
        format = "binary";
      };
    };
  };

  programs = {
    ssh = {
      includes = [ config.sops.secrets.ssh-config.path ];
      matchBlocks = {
        "bunker" = { identityFile = "~/.ssh/id_ed25519_yorha9s_bunker_2509"; };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorha9s_github_2509";
        };
        "proxmoxnix" = {
          identityFile = "~/.ssh/id_ed25519_yorha9s_proxmoxnix_2510";
        };
      };
    };

    zsh = {
      shellAliases = { copy = "xclip -selection clipboard"; };
      initContent = ''
        secret_file="${config.sops.secrets.anthropic-api-key.path}"
        export AVANTE_ANTHROPIC_API_KEY=$(cat "$secret_file")
      '';
    };
  };
}
