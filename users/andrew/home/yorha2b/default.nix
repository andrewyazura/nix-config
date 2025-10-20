{ config, ... }: {
  sops = {
    age.sshKeyPaths = [ "/home/andrew/.ssh/id_ed25519_yorha2b_nixconfig_1510" ];
    secrets.ssh-config = {
      sopsFile = ../../../../secrets/ssh-config;
      format = "binary";
    };
  };

  programs = {
    ssh = {
      includes = [ config.sops.secrets.ssh-config.path ];
      matchBlocks = {
        "bunker" = { identityFile = "~/.ssh/id_ed25519_yorha2b_bunker_1110"; };
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519_yorha2b_github_1110";
        };
      };
    };

    zsh.shellAliases = { copy = "wl-copy"; };
  };
}
