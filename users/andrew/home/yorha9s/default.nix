{ config, ... }: {
  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha9s_nixconfig_1510" ];
    secrets = {
      bw-password = {
        sopsFile = ../../../../secrets/bw-password;
        format = "binary";
      };

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
        "bunker" = { identityFile = "~/.ssh/id_ed25519_yorha9s_bunker_2509"; };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorha9s_github_2509";
        };
      };
    };

    git = {
      includes = [{
        condition = "gitdir:~/Documents/";
        contents = {
          gpg.format = "ssh";
          commit.gpgsign = true;
          user.signingkey = "~/.ssh/id_ed25519_yorha9s_github_sign_2509.pub";
        };
      }];
    };

    zsh = {
      initContent = ''
        bw-unlock() {
          export BW_SESSION=$(bw unlock --raw --passwordfile ${config.sops.secrets.bw-password.path})
        }
      '';
      shellAliases = { copy = "xclip -selection clipboard"; };
    };
  };
}
