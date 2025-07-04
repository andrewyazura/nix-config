let username = "andrew";
in {
  imports = [ ../../home ];
  modules = {
    ghostty.enable = true;
    git.enable = true;
    neovim.enable = true;
    ssh.enable = true;
    zsh.enable = true;
  };

  home = {
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.11";
  };
}
