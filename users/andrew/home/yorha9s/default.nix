{ config, ... }: {
  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha9s_nixconfig_1510" ];
    secrets.ssh-config = {
      sopsFile = ../../../../secrets/ssh-config;
      format = "binary";
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

    zsh.shellAliases = { copy = "xclip -selection clipboard"; };
  };
}
