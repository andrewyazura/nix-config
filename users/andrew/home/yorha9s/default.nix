{
  programs.ssh.matchBlocks = {
    "bunker" = { identityFile = "~/.ssh/id_ed25519_yorha9s_bunker_2509"; };
    "github.com" = { identityFile = "~/.ssh/id_ed25519_yorha9s_github_2509"; };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    includes = [{
      condition = "gitdir:~/Documents/";
      contents = {
        gpg.format = "ssh";
        user.signingkey = "~/.ssh/id_ed25519_yorha9s_github_sign_2509.pub";
      };
    }];
  };
}
