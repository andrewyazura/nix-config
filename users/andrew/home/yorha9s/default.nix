{ config, ... }: {
  programs.ssh.matchBlocks = {
    "bunker" = { identityFile = "~/.ssh/id_ed25519_yorha9s_bunker_2509"; };
    "github.com" = { identityFile = "~/.ssh/id_ed25519_yorha9s_github_2509"; };
  };

  programs.git = {
    includes = [{
      condition = "gitdir:~/Documents/";
      contents = {
        gpg.format = "ssh";
        commit.gpgsign = true;
        user.signingkey = "~/.ssh/id_ed25519_yorha9s_github_sign_2509.pub";
      };
    }];
  };

  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha9s_nixconfig_1510" ];
    secrets.ssh-config = {
      sopsFile = ../../../../secrets/ssh-config;
      format = "binary";
    };
  };

  programs.ssh.includes = [ config.sops.secrets.ssh-config.path ];
}
