{ config, ... }: {
  modules = { work.enable = true; };
  home.stateVersion = "25.05";

  sops = {
    age.sshKeyPaths =
      [ "/Users/andrew/.ssh/id_ed25519_yorhaA2_nixconfig_3011" ];

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
        "bunker" = { identityFile = "~/.ssh/id_ed25519_yorhaA2_bunker_0112"; };
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

        secret_file="${config.sops.secrets.anthropic-api-key.path}"
        export AVANTE_ANTHROPIC_API_KEY=$(cat "$secret_file")

        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
    };
  };
}
