{ config, ... }: {
  modules = { work.enable = true; };
  home.stateVersion = "25.05";

  sops = {
    age.sshKeyPaths =
      [ "/Users/andrew/.ssh/id_ed25519_yorhaA2_nixconfig_1811" ];

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
    git = {
      includes = [{
        condition = "gitdir:/";
        contents = {
          commit.gpgsign = true;
          user.signingkey = "970E41F6C58CCA2A";
        };
      }];
    };

    ssh = {
      includes = [ config.sops.secrets.ssh-config.path ];
      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorhaA2_github_1811";
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
      '';
    };
  };
}
