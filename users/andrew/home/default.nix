{ pkgs, ... }: {
  home = {
    username = "andrew";
    homeDirectory =
      if pkgs.stdenv.isDarwin then "/Users/andrew" else "/home/andrew";

    stateVersion = "24.11";
  };

  modules = {
    btop.enable = true;
    ghostty.enable = true;
    git.enable = true;
    neovim.enable = true;
    ssh.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };

  programs = {
    git = {
      includes = [{
        condition = "gitdir:~/Documents/";
        contents = {
          commit.gpgsign = true;
          user.signingkey = "970E41F6C58CCA2A";
        };
      }];
    };
  };
}
