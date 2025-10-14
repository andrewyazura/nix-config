{
  programs.ssh.matchBlocks = {
    "bunker" = { identityFile = "~/.ssh/id_ed25519_yorha2b_bunker_1110"; };
    "github.com" = { identityFile = "~/.ssh/id_ed25519_yorha2b_github_1110"; };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    includes = [{
      condition = "gitdir:~/Documents/";
      contents = {
        gpg.format = "ssh";
        commit.gpgsign = true;
        user.signingkey = "~/.ssh/id_ed25519_yorha2b_github_sign_1110.pub";
      };
    }];
  };
}
