{
  home = {
    username = "andrew";
    homeDirectory = "/home/andrew";
  };

  modules = {
    btop.enable = true;
    direnv.enable = true;
    ghostty.enable = true;
    git.enable = true;
    neovim.enable = true;
    spotify.enable = true;
    ssh.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zsh.enable = true;

    packages = {
      base.enable = true;
      development.enable = true;
    };
  };

  programs = {
    git = {
      includes = [
        {
          condition = "gitdir:~/Documents/";
          contents = {
            commit.gpgsign = true;
            user.signingkey = "970E41F6C58CCA2A";
          };
        }
      ];
    };
  };
}
