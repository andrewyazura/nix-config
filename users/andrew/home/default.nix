{
  home = {
    username = "andrew";
    homeDirectory = "/home/andrew";
  };

  modules.profiles.base.enable = true;

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
